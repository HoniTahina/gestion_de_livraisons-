const OrderItem = require("../models/OrderItem");

exports.create = (data, options = {}) => {
  return OrderItem.create(data, options);
};