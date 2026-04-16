const Order = require("../models/Order");
const OrderItem = require("../models/OrderItem");
const Product = require("../models/Product");
const SubOrder = require("../models/SubOrder");
const Delivery = require("../models/Delivery");
const User = require("../models/User");

const defaultIncludes = [
  {
    model: OrderItem,
    include: [{ model: Product }],
  },
  {
    model: User,
    attributes: ["id", "name", "email", "role"],
  },
  {
    model: User,
    as: "vendor",
    attributes: ["id", "name", "email"],
  },
  {
    model: SubOrder,
    include: [
      {
        model: User,
        as: "vendor",
        attributes: ["id", "name", "email"],
      },
      {
        model: Delivery,
      },
    ],
  },
];

const includesWithDelivery = [
  ...defaultIncludes,
];

exports.create = (data, options = {}) => {
  return Order.create(data, options);
};

exports.findAllWithDetails = () => {
  return Order.findAll({ include: includesWithDelivery, order: [["createdAt", "DESC"]] });
};

exports.findByUser = (userId) => {
  return Order.findAll({ where: { UserId: userId }, include: includesWithDelivery, order: [["createdAt", "DESC"]] });
};

exports.findByVendor = (vendorId) => {
  return Order.findAll({
    include: [
      {
        model: OrderItem,
        include: [{ model: Product }],
      },
      {
        model: User,
        attributes: ["id", "name", "email", "role"],
      },
      {
        model: User,
        as: "vendor",
        attributes: ["id", "name", "email"],
      },
      {
        model: SubOrder,
        where: { vendorId },
        include: [
          {
            model: User,
            as: "vendor",
            attributes: ["id", "name", "email"],
          },
          {
            model: Delivery,
          },
        ],
      },
    ],
    order: [["createdAt", "DESC"]],
  });
};

exports.findById = (orderId) => {
  return Order.findByPk(orderId, { include: includesWithDelivery });
};

exports.findByDeliveryPerson = (deliveryPersonId) => {
  return Order.findAll({
    include: [
      {
        model: OrderItem,
        include: [{ model: Product }],
      },
      {
        model: User,
        attributes: ["id", "name", "email", "role"],
      },
      {
        model: User,
        as: "vendor",
        attributes: ["id", "name", "email"],
      },
      {
        model: SubOrder,
        include: [
          {
            model: User,
            as: "vendor",
            attributes: ["id", "name", "email"],
          },
          {
            model: Delivery,
            where: { deliveryPersonId },
          },
        ],
      },
    ],
    order: [["createdAt", "DESC"]],
  });
};
