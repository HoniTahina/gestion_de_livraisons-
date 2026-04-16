const orderService = require("../services/orderService");

exports.createOrder = async (req, res) => {
  try {
    const { items } = req.body;
    const orders = await orderService.createOrder(req.user, items);
    res.status(201).json(orders);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.getOrders = async (req, res) => {
  try {
    const orders = await orderService.getOrders(req.user);
    res.json(orders);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.updateStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;
    const updated = await orderService.updateOrderStatus(req.user, id, status);
    res.json(updated);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};