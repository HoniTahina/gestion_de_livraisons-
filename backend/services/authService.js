const userRepo = require("../repositories/userRepository");

exports.register = async (data) => {
  // logique métier
  const existing = await userRepo.findByEmail(data.email);

  if (existing) {
    throw new Error("Email déjà utilisé");
  }

  return userRepo.createUser(data);
};