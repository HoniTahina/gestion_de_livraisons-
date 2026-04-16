const { User, Product, Order, Delivery } = require("../models");
const bcrypt = require("bcryptjs");

exports.getStats = async (req, res) => {
  const users = await User.count();
  const products = await Product.count();
  const orders = await Order.count();
  const deliveries = await Delivery.count();

  res.json({ users, products, orders, deliveries });
};

exports.createUser = async (req, res) => {
  try {
    const { name, email, password, role } = req.body;

    // Vérifier que le rôle est valide pour la création admin
    if (!["vendeur", "livreur"].includes(role)) {
      return res.status(400).json({ error: "Rôle invalide. Seuls vendeur et livreur peuvent être créés par l'admin." });
    }

    // Vérifier si l'email existe déjà
    const existing = await User.findOne({ where: { email } });
    if (existing) {
      return res.status(400).json({ error: "Email déjà utilisé" });
    }

    // Hasher le mot de passe
    const hashedPassword = await bcrypt.hash(password, 10);

    // Créer l'utilisateur
    const user = await User.create({
      name,
      email,
      password: hashedPassword,
      role
    });

    res.status(201).json({
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
