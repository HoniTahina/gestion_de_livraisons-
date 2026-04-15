const Delivery = require("../models/Delivery");

exports.create = (data) => {
  return Delivery.create(data);
};

exports.findAll = () => {
  return Delivery.findAll();
};

exports.countActiveByDeliveryPerson = (deliveryPersonId) => {
  return Delivery.count({
    where: {
      deliveryPersonId,
      status: "PENDING",
    },
  });
};

exports.findById = (id) => {
  return Delivery.findByPk(id);
};