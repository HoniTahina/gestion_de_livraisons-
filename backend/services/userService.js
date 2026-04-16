const userRepo = require("../repositories/userRepository");
const bcrypt = require("bcryptjs");

exports.getUsers = async () => {
  return userRepo.findAll();
};

exports.getProfile = async (userId) => {
  const user = await userRepo.findById(userId);
  if (!user) {
    throw new Error("Utilisateur introuvable");
  }

  return {
    id: user.id,
    name: user.name,
    email: user.email,
    role: user.role,
  };
};

exports.updateProfile = async (userId, data) => {
  const payload = {};

  if (typeof data.name === "string" && data.name.trim()) {
    payload.name = data.name.trim();
  }

  if (typeof data.email === "string" && data.email.trim()) {
    payload.email = data.email.trim().toLowerCase();
  }

  if (typeof data.password === "string" && data.password.length >= 6) {
    payload.password = await bcrypt.hash(data.password, 10);
  }

  if (Object.keys(payload).length === 0) {
    throw new Error("Aucune donnee valide a mettre a jour");
  }

  const updated = await userRepo.updateById(userId, payload);
  if (!updated) {
    throw new Error("Utilisateur introuvable");
  }

  return {
    id: updated.id,
    name: updated.name,
    email: updated.email,
    role: updated.role,
  };
};
