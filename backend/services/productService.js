const productRepo = require("../repositories/productRepository");

exports.createProduct = async (data) => {
  if (data.stock < 0) {
    throw new Error("Stock invalide");
  }

  return productRepo.create(data);
};

exports.getAllProducts = async () => {
  return productRepo.findAll();
};