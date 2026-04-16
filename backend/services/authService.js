const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const userRepo = require("../repositories/userRepository");
const { InvitationCode } = require("../models");

const JWT_SECRET = process.env.JWT_SECRET;

exports.register = async (data) => {
  const existing = await userRepo.findByEmail(data.email);
  if (existing) {
    throw new Error("Email déjà utilisé");
  }

  if (!data.name || !data.email || !data.password) {
    throw new Error("Données d'inscription incomplètes");
  }

  const hashedPassword = await bcrypt.hash(data.password, 10);

  // Détermination automatique du rôle
  let role = 'client'; // rôle par défaut
  let invitationCode = null;

  // Si un code d'invitation est fourni, le valider et déterminer le rôle
  if (data.invitationCode && data.invitationCode.trim() !== '') {
    const { validateCode } = require("../controllers/invitationController");
    const validation = await validateCode(data.invitationCode);

    if (!validation.valid) {
      throw new Error(validation.error);
    }

    role = validation.role;
    invitationCode = validation.codeData;
  }

  const user = await userRepo.createUser({
    name: data.name,
    email: data.email,
    password: hashedPassword,
    role,
  });

  // Marquer le code d'invitation comme utilisé
  if (invitationCode) {
    invitationCode.usedBy = user.id;
    invitationCode.isUsed = true;
    await invitationCode.save();
  }

  return user;
};

exports.login = async (data) => {
  const user = await userRepo.findByEmail(data.email);
  if (!user) {
    throw new Error("Email ou mot de passe incorrect");
  }

  const validPassword = await bcrypt.compare(data.password, user.password);
  if (!validPassword) {
    throw new Error("Email ou mot de passe incorrect");
  }

  const token = jwt.sign(
    { id: user.id, role: user.role, email: user.email, name: user.name },
    JWT_SECRET,
    { expiresIn: "8h" }
  );

  return {
    token,
    user: {
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
    },
  };
};