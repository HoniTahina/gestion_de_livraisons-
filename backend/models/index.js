const User = require("./User");
const Product = require("./Product");
const Order = require("./Order");
const OrderItem = require("./OrderItem");
const Delivery = require("./Delivery");

// relations
User.hasMany(Order);
Order.belongsTo(User);

Order.hasMany(OrderItem);
OrderItem.belongsTo(Order);

Product.hasMany(OrderItem);
OrderItem.belongsTo(Product);

// relation avec Order
Delivery.belongsTo(Order);
Order.hasOne(Delivery);

// relation avec livreur (User)
Delivery.belongsTo(User, { as: "deliveryPerson" });
User.hasMany(Delivery, { foreignKey: "deliveryPersonId" });