const productRepo = require("../repositories/productRepository");
const { CacheStore } = require("../utils/cache");

const productsCache = new CacheStore(30000);
const PRODUCTS_CACHE_KEY = "products:list";

exports.createProduct = async (data, user) => {
  if (!data.name || data.price == null) {
    throw new Error("Nom et prix requis");
  }

  if (data.stock < 0) {
    throw new Error("Stock invalide");
  }

  const created = await productRepo.create({
    name: data.name,
    price: data.price,
    stock: data.stock ?? 0,
    category: data.category || "Autre",
    vendorId: user.id,
  });

  productsCache.del(PRODUCTS_CACHE_KEY);
  return created;
};

exports.getAllProducts = async () => {
  const cached = productsCache.get(PRODUCTS_CACHE_KEY);
  if (cached) {
    return cached;
  }

  const products = await productRepo.findAll();
  productsCache.set(PRODUCTS_CACHE_KEY, products);
  return products;
};

exports.updateProduct = async (id, data, user) => {
  const product = await productRepo.findById(id);
  if (!product) {
    throw new Error("Produit introuvable");
  }

  if (user.role !== "admin" && product.vendorId !== user.id) {
    throw new Error("Acces refuse");
  }

  const payload = {};

  if (typeof data.name === "string" && data.name.trim()) {
    payload.name = data.name.trim();
  }
  if (data.price != null) {
    const price = Number(data.price);
    if (!Number.isFinite(price) || price < 0) {
      throw new Error("Prix invalide");
    }
    payload.price = price;
  }
  if (data.stock != null) {
    const stock = Number(data.stock);
    if (!Number.isInteger(stock) || stock < 0) {
      throw new Error("Stock invalide");
    }
    payload.stock = stock;
  }
  if (typeof data.category === "string" && data.category.trim()) {
    payload.category = data.category.trim();
  }

  if (Object.keys(payload).length === 0) {
    throw new Error("Aucune donnee a mettre a jour");
  }

  const updated = await productRepo.updateById(id, payload);
  productsCache.del(PRODUCTS_CACHE_KEY);
  return updated;
};