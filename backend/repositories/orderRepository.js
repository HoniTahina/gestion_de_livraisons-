const Order = require("../models/Order");

exports.create = (data) => {
  return Order.create(data);
};

exports.findAll = () => {
  return Order.findAll();
};