const userRepo = require("../repositories/userRepository");

exports.getUsers = async () => {
  return userRepo.findAll();
};
