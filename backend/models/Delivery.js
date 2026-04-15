const { DataTypes } = require("sequelize");
const sequelize = require("../config/db");

const Delivery = sequelize.define("Delivery", {
  status: {
    type: DataTypes.STRING,
    defaultValue: "PENDING",
  },
});

module.exports = Delivery;