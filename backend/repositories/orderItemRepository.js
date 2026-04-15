const OrderItem = require("../models/OrderItem");

exports.create = (data) => {
  return OrderItem.create(data);
};