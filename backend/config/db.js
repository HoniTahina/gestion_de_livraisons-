const { Sequelize } = require("sequelize");

const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USER,
  process.env.DB_PASS,
  {
    host: process.env.DB_HOST || "localhost",
    dialect: "postgres",
    logging: false,
    retry: {
      max: 10,
      timeout: 1000,
    },
  }
);

module.exports = sequelize;