import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../services/api';

export default function RegisterPage() {
  const [form, setForm] = useState({
    name: '',
    email: '',
    password: '',
    invitationCode: ''
  });
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const [success, setSuccess] = useState(false);
  const [detectedRole, setDetectedRole] = useState('client');
  const navigate = useNavigate();

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm({ ...form, [name]: value });
    if (error) setError(''); // clear error on change

    // Détecter automatiquement le rôle basé sur le code d'invitation
    if (name === 'invitationCode') {
      if (value.trim() === '') {
        setDetectedRole('client');
      } else {
        // On laisse le backend valider le code et déterminer le rôle
        setDetectedRole('pending'); // En attente de validation
      }
    }
  };

  const validateForm = () => {
    if (!form.name || !form.email || !form.password) {
      setError('Tous les champs sont requis');
      return false;
    }
    if (form.name.length < 2) {
      setError('Le nom doit contenir au moins 2 caractères');
      return false;
    }
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(form.email)) {
      setError('Email invalide');
      return false;
    }
    if (form.password.length < 6) {
      setError('Le mot de passe doit contenir au moins 6 caractères');
      return false;
    }
    return true;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!validateForm()) return;

    setLoading(true);
    try {
      const response = await api.post('/auth/register', form);
      const assignedRole = response.data.role || 'client';
      setDetectedRole(assignedRole);
      setSuccess(true);
      setTimeout(() => navigate('/login'), 2000);
    } catch (err) {
      if (err.response?.data?.error) {
        setError(err.response.data.error);
      } else {
        setError('Erreur lors de l\'inscription. Email déjà utilisé ?');
      }
    } finally {
      setLoading(false);
    }
  };

  if (success) {
    return (
      <div style={styles.container}>
        <div style={styles.card}>
          <h2 style={styles.title}>Inscription réussie !</h2>
          <p style={styles.subtitle}>Redirection vers la page de connexion...</p>
        </div>
      </div>
    );
  }

  return (
    <div style={styles.container}>
      <div style={styles.card}>
        <h2 style={styles.title}>Créer un compte</h2>
        <p style={styles.subtitle}>Rejoignez notre plateforme de livraison</p>

        <form onSubmit={handleSubmit} style={styles.form}>
          <div style={styles.inputGroup}>
            <label style={styles.label}>Nom complet</label>
            <input
              name="name"
              placeholder="Votre nom"
              value={form.name}
              onChange={handleChange}
              style={styles.input}
              disabled={loading}
            />
          </div>

          <div style={styles.inputGroup}>
            <label style={styles.label}>Email</label>
            <input
              name="email"
              type="email"
              placeholder="votre.email@exemple.com"
              value={form.email}
              onChange={handleChange}
              style={styles.input}
              disabled={loading}
            />
          </div>

          <div style={styles.inputGroup}>
            <label style={styles.label}>Mot de passe</label>
            <input
              name="password"
              type="password"
              placeholder="Au moins 6 caractères"
              value={form.password}
              onChange={handleChange}
              style={styles.input}
              disabled={loading}
            />
          </div>

          <div style={styles.inputGroup}>
            <label style={styles.label}>Code d'invitation (optionnel)</label>
            <input
              name="invitationCode"
              type="text"
              placeholder="Laissez vide pour un compte client"
              value={form.invitationCode}
              onChange={handleChange}
              style={styles.input}
              disabled={loading}
            />
            <small style={styles.helpText}>
              {detectedRole === 'client' && "Compte client standard - accès aux achats"}
              {detectedRole === 'pending' && "Vérification du code d'invitation en cours..."}
              {detectedRole === 'vendeur' && "✅ Compte vendeur détecté - accès à la gestion des produits"}
              {detectedRole === 'livreur' && "✅ Compte livreur détecté - accès à la gestion des livraisons"}
            </small>
            <small style={styles.helpTextMuted}>
              Pour vendeur/livreur: un administrateur valide d'abord votre profil, puis vous transmet le code.
            </small>
          </div>
          <button type="submit" style={styles.button} disabled={loading}>
            {loading ? 'Création...' : 'Créer mon compte'}
          </button>
        </form>

        {error && <p style={styles.error}>{error}</p>}

        <p style={styles.link}>
          Déjà un compte ? <a href="/login" style={styles.linkText}>Se connecter</a>
        </p>
      </div>
    </div>
  );
}

const styles = {
  container: {
    minHeight: '100vh',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
    padding: '20px'
  },
  card: {
    background: 'white',
    borderRadius: '12px',
    padding: '40px',
    boxShadow: '0 15px 35px rgba(0,0,0,0.1)',
    width: '100%',
    maxWidth: '400px',
    textAlign: 'center'
  },
  title: {
    margin: '0 0 10px 0',
    color: '#333',
    fontSize: '28px',
    fontWeight: 'bold'
  },
  subtitle: {
    margin: '0 0 30px 0',
    color: '#666',
    fontSize: '16px'
  },
  form: {
    display: 'flex',
    flexDirection: 'column',
    gap: '20px'
  },
  inputGroup: {
    textAlign: 'left'
  },
  label: {
    display: 'block',
    marginBottom: '5px',
    color: '#555',
    fontWeight: '500'
  },
  input: {
    width: '100%',
    padding: '12px 15px',
    border: '2px solid #e1e5e9',
    borderRadius: '8px',
    fontSize: '16px',
    transition: 'border-color 0.3s',
    boxSizing: 'border-box'
  },
  select: {
    width: '100%',
    padding: '12px 15px',
    border: '2px solid #e1e5e9',
    borderRadius: '8px',
    fontSize: '16px',
    background: 'white',
    boxSizing: 'border-box'
  },
  helpText: {
    display: 'block',
    marginTop: '5px',
    fontSize: '14px',
    color: '#666',
    fontStyle: 'italic'
  },
  helpTextMuted: {
    display: 'block',
    marginTop: '6px',
    fontSize: '12px',
    color: '#8a8a8a'
  },
  button: {
    background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
    color: 'white',
    border: 'none',
    padding: '15px',
    borderRadius: '8px',
    fontSize: '16px',
    fontWeight: 'bold',
    cursor: 'pointer',
    transition: 'transform 0.2s',
    marginTop: '10px'
  },
  error: {
    color: '#e74c3c',
    margin: '15px 0 0 0',
    fontSize: '14px'
  },
  link: {
    margin: '20px 0 0 0',
    color: '#666',
    fontSize: '14px'
  },
  linkText: {
    color: '#667eea',
    textDecoration: 'none',
    fontWeight: 'bold'
  }
};