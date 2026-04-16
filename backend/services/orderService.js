const orderRepo = require("../repositories/orderRepository");
const orderItemRepo = require("../repositories/orderItemRepository");
const deliveryRepo = require("../repositories/deliveryRepository");
const { Product, SubOrder } = require("../models");
const sequelize = require("../config/db");
const crypto = require("crypto");
const { publishEvent } = require("../utils/realtime");

const COMMISSION_RATE = 0.05; // taux de commission pour les vendeurs

const ensureDeliveriesForPaidOrder = async (order) => {
  const subOrders = Array.isArray(order.SubOrders) ? order.SubOrders : [];

  for (const subOrder of subOrders) {
    const existingDelivery = subOrder.Delivery || (await deliveryRepo.findBySubOrderId(subOrder.id));

    if (existingDelivery) {
      continue;
    }

    const delivery = await deliveryRepo.create({
      SubOrderId: subOrder.id,
      status: "PROCESSING",
      deliveryPersonId: null,
      trackingToken: crypto.randomBytes(8).toString("hex"),
    });

    publishEvent("delivery.created", { deliveryId: delivery.id, subOrderId: subOrder.id });
  }
};

exports.createOrder = async (user, items) => {
  if (!items || !Array.isArray(items) || items.length === 0) {
    throw new Error("Le panier est vide");
  }

  return sequelize.transaction(async (transaction) => {
    const groupedByVendor = {};

    for (const item of items) {
      const quantity = Number(item.quantity);
      if (!Number.isInteger(quantity) || quantity <= 0) {
        throw new Error("Quantite invalide");
      }

      const product = await Product.findByPk(item.productId, {
        transaction,
        lock: transaction.LOCK.UPDATE,
      });

      if (!product) {
        throw new Error(`Produit introuvable : ${item.productId}`);
      }

      if (product.stock < quantity) {
        throw new Error(`Stock insuffisant pour ${product.name}`);
      }

      const vendorId = product.vendorId;
      if (!groupedByVendor[vendorId]) {
        groupedByVendor[vendorId] = [];
      }

      groupedByVendor[vendorId].push({ product, quantity });
    }

    const vendorIds = Object.keys(groupedByVendor).map((id) => Number(id)).filter(Number.isFinite);
    const primaryVendorId = vendorIds.length > 0 ? vendorIds[0] : null;

    const order = await orderRepo.create(
      {
        UserId: user.id,
        vendorId: primaryVendorId,
        supplierId: primaryVendorId,
        status: "PENDING",
        total: 0,
        commission: 0,
      },
      { transaction }
    );

    let orderTotal = 0;

    for (const vendorId of Object.keys(groupedByVendor)) {
      const itemsForVendor = groupedByVendor[vendorId];
      let subTotal = 0;

      const subOrder = await SubOrder.create(
        {
          OrderId: order.id,
          vendorId: Number(vendorId),
          subtotal: 0,
          status: "PENDING",
        },
        { transaction }
      );

      for (const { product, quantity } of itemsForVendor) {
        const lineTotal = product.price * quantity;
        subTotal += lineTotal;
        orderTotal += lineTotal;

        await orderItemRepo.create(
          {
            OrderId: order.id,
            SubOrderId: subOrder.id,
            ProductId: product.id,
            quantity,
            price: product.price,
          },
          { transaction }
        );

        product.stock -= quantity;
        await product.save({ transaction });
      }

      subOrder.subtotal = subTotal;
      await subOrder.save({ transaction });
    }

    const commission = Number((orderTotal * COMMISSION_RATE).toFixed(2));
    order.total = orderTotal;
    order.commission = commission;
    await order.save({ transaction });

    return order;
  });
};

exports.getOrders = async (user) => {
  if (user.role === "admin") {
    return orderRepo.findAllWithDetails();
  }

  if (user.role === "vendeur") {
    return orderRepo.findByVendor(user.id);
  }

  if (user.role === "livreur") {
    return orderRepo.findByDeliveryPerson(user.id);
  }

  return orderRepo.findByUser(user.id);
};

exports.updateOrderStatus = async (user, orderId, status) => {
  const allowedStatuses = ["PENDING", "PAID", "SHIPPED", "DELIVERED"];
  if (!allowedStatuses.includes(status)) {
    throw new Error("Statut invalide");
  }

  const order = await orderRepo.findById(orderId);
  if (!order) {
    throw new Error("Commande introuvable");
  }

  if (user.role === "client") {
    if (order.UserId !== user.id) {
      throw new Error("Accès refusé");
    }
    if (status !== "PAID") {
      throw new Error("Le client ne peut que payer la commande");
    }
  }

  if (user.role === "vendeur") {
    if (order.vendorId !== user.id) {
      throw new Error("Accès refusé");
    }
    if (status !== "SHIPPED") {
      throw new Error("Le vendeur ne peut que expédier la commande");
    }
  }

  if (user.role === "livreur") {
    if (status !== "DELIVERED") {
      throw new Error("Le livreur ne peut que marquer la commande comme livrée");
    }
  }

  if (user.role === "admin") {
    // admin peut changer tous les statuts
  }

  order.status = status;
  await order.save();

  if (status === "PAID") {
    await ensureDeliveriesForPaidOrder(order);
  }

  return order;
};