const deliveryService = require("../services/deliveryService");

exports.assignDelivery = async (req, res) => {
  try {
    const { orderId, deliveryPersonId } = req.body;

    const delivery = await deliveryService.assignDelivery(orderId, deliveryPersonId);

    res.status(201).json(delivery);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.updateStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const delivery = await deliveryService.updateStatus(req.user, id, status);

    res.json(delivery);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.getDeliveries = async (req, res) => {
  try {
    const deliveries = await deliveryService.getDeliveries(req.user);
    res.json(deliveries);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};