const Delivery = require("../models/Delivery");
const Order = require("../models/Order");
const SubOrder = require("../models/SubOrder");
const User = require("../models/User");
const { Op } = require("sequelize");

exports.create = (data) => {
  return Delivery.create(data);
};

exports.findAll = () => {
  return Delivery.findAll({
    include: [
      { model: SubOrder, include: [{ model: Order }] },
      { model: User, as: "deliveryPerson", attributes: ["id", "name", "email"] },
    ],
    order: [["createdAt", "DESC"]],
  });
};

exports.countActiveByDeliveryPerson = (deliveryPersonId) => {
  return Delivery.count({
    where: {
      deliveryPersonId,
      status: { [Op.in]: ["PROCESSING", "ASSIGNED", "IN_TRANSIT"] },
    },
  });
};

exports.findById = (id) => {
  return Delivery.findByPk(id, {
    include: [
      { model: SubOrder, include: [{ model: Order }] },
      { model: User, as: "deliveryPerson", attributes: ["id", "name", "email"] },
    ],
  });
};

exports.findBySubOrderId = (subOrderId) => {
  return Delivery.findOne({ where: { SubOrderId: subOrderId } });
};

exports.findByOrderId = (orderId) => {
  return Delivery.findAll({
    include: [
      {
        model: SubOrder,
        where: { OrderId: orderId },
      },
    ],
  });
};

exports.findByDeliveryPerson = (deliveryPersonId) => {
  return Delivery.findAll({
    where: { deliveryPersonId },
    include: [
      { model: SubOrder, include: [{ model: Order }] },
      { model: User, as: "deliveryPerson", attributes: ["id", "name", "email"] },
    ],
    order: [["createdAt", "DESC"]],
  });
};

exports.findByClientOrders = (userId) => {
  return Delivery.findAll({
    include: [
      {
        model: SubOrder,
        include: [
          {
            model: Order,
            where: { UserId: userId },
          },
        ],
      },
      { model: User, as: "deliveryPerson", attributes: ["id", "name", "email"] },
    ],
    order: [["createdAt", "DESC"]],
  });
};