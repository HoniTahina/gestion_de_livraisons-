const userService = require("../services/userService");

exports.getUsers = async (req, res) => {
  const users = await userService.getUsers();
  res.json(users);
};