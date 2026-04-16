const User = require("../models/User");

exports.createUser = (data) => {
  return User.create(data);
};

exports.findByEmail = (email) => {
  return User.findOne({ where: { email } });
};

exports.findAll = () => {
  return User.findAll();
};

exports.findById = (id) => {
  return User.findByPk(id);
};

exports.updateById = async (id, data) => {
  const user = await User.findByPk(id);
  if (!user) {
    return null;
  }

  await user.update(data);
  return user;
};