const { DataTypes } = require("sequelize");
const sequelize = require("../config/db");

const Order = sequelize.define("Order", {
  status: {
    type: DataTypes.STRING,
    defaultValue: "PENDING",
  },
  total: {
    type: DataTypes.FLOAT,
    defaultValue: 0,
  },
  commission: {
    type: DataTypes.FLOAT,
    defaultValue: 0,
  },
  vendorId: {
    type: DataTypes.INTEGER,
    allowNull: true,
  },
  supplierId: {
    type: DataTypes.INTEGER,
    allowNull: true,
  },
});

module.exports = Order;