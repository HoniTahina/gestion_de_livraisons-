const Product = require("../models/Product");

exports.create = (data) => {
  return Product.create(data);
};

exports.findAll = () => {
  return Product.findAll();
};

exports.findById = (id) => {
  return Product.findByPk(id);
};