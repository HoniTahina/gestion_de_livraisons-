const { DataTypes } = require("sequelize");
const sequelize = require("../config/db");

const SubOrder = sequelize.define("SubOrder", {
  vendorId: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  subtotal: {
    type: DataTypes.FLOAT,
    defaultValue: 0,
  },
  status: {
    type: DataTypes.ENUM("PENDING", "SHIPPED", "DELIVERED"),
    defaultValue: "PENDING",
  },
});

module.exports = SubOrder;