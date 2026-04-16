const deliveryRepo = require("../repositories/deliveryRepository");
const orderRepo = require("../repositories/orderRepository");
const crypto = require("crypto");
const { publishEvent } = require("../utils/realtime");

const STATUS_FLOW = ["PROCESSING", "IN_TRANSIT", "DONE"];
const normalizeStatus = (status) => (status === "ASSIGNED" ? "PROCESSING" : status);

exports.assignDelivery = async (orderId, deliveryPersonId) => {
  const order = await orderRepo.findById(orderId);
  if (!order) {
    throw new Error("Commande introuvable");
  }

  if (order.status !== "PAID") {
    throw new Error("La commande doit être payée avant d'être assignée");
  }

  const subOrders = Array.isArray(order.SubOrders) ? order.SubOrders : [];
  if (subOrders.length === 0) {
    throw new Error("Aucune sous-commande à livrer");
  }

  const active = await deliveryRepo.countActiveByDeliveryPerson(deliveryPersonId);
  if (active >= 3) {
    throw new Error("Livreur déjà occupé (max 3 livraisons)");
  }

  const created = [];

  for (const subOrder of subOrders) {
    const existing = await deliveryRepo.findBySubOrderId(subOrder.id);

    if (existing?.deliveryPersonId) {
      continue;
    }

    let delivery;

    if (existing) {
      existing.deliveryPersonId = deliveryPersonId;
      existing.status = normalizeStatus(existing.status) || "PROCESSING";
      if (!existing.trackingToken) {
        existing.trackingToken = crypto.randomBytes(8).toString("hex");
      }
      delivery = await existing.save();
    } else {
      delivery = await deliveryRepo.create({
        SubOrderId: subOrder.id,
        deliveryPersonId,
        status: "PROCESSING",
        trackingToken: crypto.randomBytes(8).toString("hex"),
      });
    }

    created.push(delivery);
  }

  if (created.length === 0) {
    throw new Error("Toutes les sous-commandes sont déjà assignées");
  }

  for (const delivery of created) {
    publishEvent("delivery.created", { deliveryId: delivery.id });
  }

  return created;
};

exports.updateStatus = async (user, deliveryId, status) => {
  const allowedStatuses = ["PROCESSING", "IN_TRANSIT", "DONE"];
  if (!allowedStatuses.includes(status)) {
    throw new Error("Statut de livraison invalide");
  }

  const delivery = await deliveryRepo.findById(deliveryId);
  if (!delivery) {
    throw new Error("Livraison introuvable");
  }

  if (user.role === "livreur" && delivery.deliveryPersonId !== user.id) {
    throw new Error("Accès refusé");
  }

  const currentIdx = STATUS_FLOW.indexOf(normalizeStatus(delivery.status));
  const nextIdx = STATUS_FLOW.indexOf(status);

  if (currentIdx === -1 || nextIdx === -1 || nextIdx < currentIdx) {
    throw new Error("Transition de statut invalide");
  }

  delivery.status = status;
  await delivery.save();

  publishEvent("delivery.updated", {
    deliveryId: delivery.id,
    status: delivery.status,
  });

  return delivery;
};

exports.getDeliveries = async (user) => {
  if (user.role === "admin") {
    return deliveryRepo.findAll();
  }

  if (user.role === "livreur") {
    return deliveryRepo.findByDeliveryPerson(user.id);
  }

  if (user.role === "client") {
    return deliveryRepo.findByClientOrders(user.id);
  }

  return deliveryRepo.findAll();
};