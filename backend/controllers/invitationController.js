const { InvitationCode, User } = require("../models");
const crypto = require('crypto');

exports.generateCode = async (req, res) => {
  try {
    const { role, expiresInDays } = req.body; // role: 'vendeur' ou 'livreur'

    if (!['vendeur', 'livreur'].includes(role)) {
      return res.status(400).json({ error: 'Rôle invalide. Seuls vendeur et livreur sont autorisés.' });
    }

    // Générer un code unique
    const code = crypto.randomBytes(4).toString('hex').toUpperCase();

    // Calculer la date d'expiration
    const expiresAt = expiresInDays
      ? new Date(Date.now() + expiresInDays * 24 * 60 * 60 * 1000)
      : null;

    const invitationCode = await InvitationCode.create({
      code,
      role,
      expiresAt,
      createdBy: req.user.id
    });

    res.status(201).json({
      code: invitationCode.code,
      role: invitationCode.role,
      expiresAt: invitationCode.expiresAt,
      message: `Code d'invitation généré: ${invitationCode.code}`
    });
  } catch (err) {
    console.error('Erreur génération code:', err);
    res.status(500).json({ error: err.message });
  }
};

exports.getCodes = async (req, res) => {
  try {
    const codes = await InvitationCode.findAll({
      where: { createdBy: req.user.id },
      include: [
        { model: User, as: 'user', attributes: ['name', 'email'] }
      ],
      order: [['createdAt', 'DESC']]
    });

    res.json(codes);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.validateCode = async (code) => {
  try {
    const invitationCode = await InvitationCode.findOne({
      where: {
        code: code.toUpperCase(),
        isUsed: false
      }
    });

    if (!invitationCode) {
      return { valid: false, error: 'Code d\'invitation invalide ou déjà utilisé' };
    }

    if (invitationCode.expiresAt && invitationCode.expiresAt < new Date()) {
      return { valid: false, error: 'Code d\'invitation expiré' };
    }

    return {
      valid: true,
      role: invitationCode.role,
      codeData: invitationCode
    };
  } catch (err) {
    return { valid: false, error: 'Erreur lors de la validation du code' };
  }
};

exports.markCodeAsUsed = async (codeId, userId) => {
  try {
    await InvitationCode.update(
      { isUsed: true, usedBy: userId },
      { where: { id: codeId } }
    );
  } catch (err) {
    console.error('Erreur marquage code utilisé:', err);
  }
};