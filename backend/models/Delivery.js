const { DataTypes } = require("sequelize");
const sequelize = require("../config/db");

const Delivery = sequelize.define("Delivery", {
  status: {
    type: DataTypes.STRING,
    defaultValue: "ASSIGNED",
  },
  deliveryPersonId: {
    type: DataTypes.INTEGER,
  },
  SubOrderId: {
    type: DataTypes.INTEGER,
    allowNull: true,
  },
  trackingToken: {
    type: DataTypes.STRING,
    allowNull: false,
  },
});

module.exports = Delivery;