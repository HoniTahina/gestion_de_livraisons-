const userService = require("../services/userService");

exports.getUsers = async (req, res) => {
  const users = await userService.getUsers();
  res.json(users);
};

exports.getProfile = async (req, res) => {
  try {
    const profile = await userService.getProfile(req.user.id);
    res.json(profile);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.updateProfile = async (req, res) => {
  try {
    const profile = await userService.updateProfile(req.user.id, req.body);
    res.json(profile);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};