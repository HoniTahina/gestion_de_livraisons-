const Product = require("../models/Product");
const User = require("../models/User");

exports.create = (data, options = {}) => {
  return Product.create(data, options);
};

exports.findAll = (options = {}) => {
  return Product.findAll({
    include: [
      {
        model: User,
        as: "vendor",
        attributes: ["id", "name"],
      },
    ],
    ...options,
    order: [["name", "ASC"]],
  });
};

exports.findById = (id, options = {}) => {
  return Product.findByPk(id, {
    include: [
      {
        model: User,
        as: "vendor",
        attributes: ["id", "name"],
      },
    ],
    ...options,
  });
};

exports.updateById = async (id, data, options = {}) => {
  const product = await Product.findByPk(id, options);
  if (!product) {
    return null;
  }

  await product.update(data, options);
  return product;
};