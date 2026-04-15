const User = require("../models/User");

exports.createUser = (data) => {
  return User.create(data);
};

exports.findByEmail = (email) => {
  return User.findOne({ where: { email } });
};