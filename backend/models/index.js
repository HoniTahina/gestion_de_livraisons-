const User = require("./User");
const Product = require("./Product");
const Order = require("./Order");
const OrderItem = require("./OrderItem");
const SubOrder = require("./SubOrder");
const Delivery = require("./Delivery");
const InvitationCode = require("./InvitationCode");

// relations utilisateurs / commandes
User.hasMany(Order);
Order.belongsTo(User);

// relation vendeur / produits
User.hasMany(Product, { foreignKey: "vendorId", as: "products" });
Product.belongsTo(User, { foreignKey: "vendorId", as: "vendor" });

// relation commande / ligne
Order.hasMany(OrderItem);
OrderItem.belongsTo(Order);

Product.hasMany(OrderItem);
OrderItem.belongsTo(Product);

// relation commande / sous-commandes
Order.hasMany(SubOrder);
SubOrder.belongsTo(Order);

// relation sous-commande / lignes
SubOrder.hasMany(OrderItem);
OrderItem.belongsTo(SubOrder);

// relation sous-commande / livraison
Delivery.belongsTo(SubOrder);
SubOrder.hasOne(Delivery);

// relation livreur
Delivery.belongsTo(User, { foreignKey: "deliveryPersonId", as: "deliveryPerson" });
User.hasMany(Delivery, { foreignKey: "deliveryPersonId", as: "deliveries" });

// relation commande vendeur
User.hasMany(Order, { foreignKey: "vendorId", as: "vendorOrders" });
Order.belongsTo(User, { foreignKey: "vendorId", as: "vendor" });

// relation sous-commande vendeur
User.hasMany(SubOrder, { foreignKey: "vendorId", as: "subOrders" });
SubOrder.belongsTo(User, { foreignKey: "vendorId", as: "vendor" });

// relation codes d'invitation
User.hasMany(InvitationCode, { foreignKey: "createdBy", as: "createdCodes" });
InvitationCode.belongsTo(User, { foreignKey: "createdBy", as: "creator" });
InvitationCode.belongsTo(User, { foreignKey: "usedBy", as: "user" });

module.exports = {
  User,
  Product,
  Order,
  OrderItem,
  SubOrder,
  Delivery,
  InvitationCode,
};