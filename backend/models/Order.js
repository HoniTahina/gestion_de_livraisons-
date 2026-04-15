const { DataTypes } = require("sequelize");
const sequelize = require("../config/db");

const Order = sequelize.define("Order", {
  status: {
    type: DataTypes.STRING,
    defaultValue: "PENDING",
  },
  total: DataTypes.FLOAT,
});

module.exports = Order;