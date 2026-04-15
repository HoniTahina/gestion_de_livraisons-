const authService = require("../services/authService");

exports.register = async (req, res) => {
  try {
    const user = await authService.register(req.body);
    res.json(user);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};