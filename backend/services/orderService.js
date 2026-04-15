const orderRepo = require("../repositories/orderRepository");
const orderItemRepo = require("../repositories/orderItemRepository");
const productRepo = require("../repositories/productRepository");

exports.createOrder = async (userId, items) => {
  let total = 0;

  // créer commande
  const order = await orderRepo.create({
    UserId: userId,
    status: "PENDING",
    total: 0,
  });

  // traiter les produits
  for (const item of items) {
    const product = await productRepo.findById(item.productId);

    if (!product) {
      throw new Error("Produit introuvable");
    }

    if (product.stock < item.quantity) {
      throw new Error("Stock insuffisant pour " + product.name);
    }

    // calcul total
    const price = product.price * item.quantity;
    total += price;

    // créer order item
    await orderItemRepo.create({
      OrderId: order.id,
      ProductId: product.id,
      quantity: item.quantity,
      price: product.price,
    });

    // mise à jour stock
    product.stock -= item.quantity;
    await product.save();
  }

  order.total = total;
  await order.save();

  return order;
};

exports.getOrders = () => {
  return orderRepo.findAll();
};