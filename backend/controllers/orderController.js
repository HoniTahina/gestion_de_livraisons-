const orderService = require("../services/orderService");

exports.createOrder = async (req, res) => {
  try {
    const { userId, items } = req.body;

    const order = await orderService.createOrder(userId, items);

    res.status(201).json(order);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.getOrders = async (req, res) => {
  const orders = await orderService.getOrders();
  res.json(orders);
};