import { useEffect, useState } from 'react';
import api from '../services/api';
import { useAuth } from '../context/AuthContext';

export default function ProfilePage() {
  const { user, updateUser } = useAuth();
  const [form, setForm] = useState({ name: '', email: '', password: '' });
  const [message, setMessage] = useState('');
  const [error, setError] = useState('');

  useEffect(() => {
    const fetchProfile = async () => {
      try {
        const res = await api.get('/users/me');
        setForm({ name: res.data.name || '', email: res.data.email || '', password: '' });
      } catch (err) {
        setError('Impossible de charger le profil');
      }
    };

    fetchProfile();
  }, []);

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
    setMessage('');
    setError('');
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      const payload = {
        name: form.name,
        email: form.email,
      };

      if (form.password.trim()) {
        payload.password = form.password;
      }

      const res = await api.put('/users/me', payload);
      updateUser(res.data);
      setForm({ ...form, password: '' });
      setMessage('Profil mis a jour avec succes');
    } catch (err) {
      setError(err.response?.data?.error || 'Erreur lors de la mise a jour');
    }
  };

  return (
    <div style={styles.container}>
      <h2>Mon profil</h2>
      <p>Role actuel: {user?.role || 'N/A'}</p>

      <form onSubmit={handleSubmit} style={styles.form}>
        <label style={styles.label}>Nom</label>
        <input name="name" value={form.name} onChange={handleChange} style={styles.input} />

        <label style={styles.label}>Email</label>
        <input name="email" type="email" value={form.email} onChange={handleChange} style={styles.input} />

        <label style={styles.label}>Nouveau mot de passe (optionnel)</label>
        <input
          name="password"
          type="password"
          value={form.password}
          onChange={handleChange}
          style={styles.input}
          placeholder="Laisser vide pour conserver l'ancien"
        />

        <button type="submit" style={styles.button}>Enregistrer</button>
      </form>

      {message && <p style={styles.success}>{message}</p>}
      {error && <p style={styles.error}>{error}</p>}
    </div>
  );
}

const styles = {
  container: {
    maxWidth: '560px',
    margin: '0 auto',
    background: 'white',
    padding: '20px',
    borderRadius: '10px',
    boxShadow: '0 2px 10px rgba(0,0,0,0.1)'
  },
  form: {
    display: 'flex',
    flexDirection: 'column',
    gap: '10px'
  },
  label: {
    fontWeight: '600'
  },
  input: {
    padding: '10px',
    border: '1px solid #ddd',
    borderRadius: '6px'
  },
  button: {
    marginTop: '10px',
    padding: '10px 14px',
    border: 'none',
    borderRadius: '6px',
    background: '#667eea',
    color: 'white',
    fontWeight: '600',
    cursor: 'pointer'
  },
  success: {
    color: '#198754',
    marginTop: '12px'
  },
  error: {
    color: '#dc3545',
    marginTop: '12px'
  }
};
