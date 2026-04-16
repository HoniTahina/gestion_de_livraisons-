const productService = require("../services/productService");

exports.createProduct = async (req, res) => {
  try {
    const product = await productService.createProduct(req.body, req.user);
    res.status(201).json(product);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.getProducts = async (req, res) => {
  const products = await productService.getAllProducts();
  res.json(products);
};

exports.updateProduct = async (req, res) => {
  try {
    const { id } = req.params;
    const product = await productService.updateProduct(id, req.body, req.user);
    res.json(product);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};