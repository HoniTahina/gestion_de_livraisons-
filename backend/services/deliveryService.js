const deliveryRepo = require("../repositories/deliveryRepository");
const orderRepo = require("../repositories/orderRepository");

exports.assignDelivery = async (orderId, deliveryPersonId) => {
  // vérifier nombre de livraisons en cours
  const active = await deliveryRepo.countActiveByDeliveryPerson(deliveryPersonId);

  if (active >= 3) {
    throw new Error("Livreur déjà occupé (max 3 livraisons)");
  }

  const delivery = await deliveryRepo.create({
    OrderId: orderId,
    deliveryPersonId,
    status: "PENDING",
  });

  return delivery;
};

exports.updateStatus = async (deliveryId, status) => {
  const delivery = await deliveryRepo.findById(deliveryId);

  if (!delivery) {
    throw new Error("Livraison introuvable");
  }

  delivery.status = status;
  await delivery.save();

  return delivery;
};

exports.getDeliveries = () => {
  return deliveryRepo.findAll();
};