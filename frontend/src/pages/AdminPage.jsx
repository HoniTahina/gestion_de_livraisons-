import { useEffect, useState } from 'react';
import api from '../services/api';

export default function AdminPage() {
  const [stats, setStats] = useState(null);
  const [newUser, setNewUser] = useState({
    name: '',
    email: '',
    password: '',
    role: 'admin'
  });
  const [message, setMessage] = useState('');
  const [invitationCodes, setInvitationCodes] = useState([]);
  const [newCode, setNewCode] = useState({
    role: 'vendeur',
    expiresInDays: 30
  });

  useEffect(() => {
    fetchStats();
    fetchInvitationCodes();
  }, []);

  const fetchStats = async () => {
    try {
      const res = await api.get('/admin/stats');
      setStats(res.data);
    } catch (err) {
      console.error(err);
    }
  };

  const fetchInvitationCodes = async () => {
    try {
      const res = await api.get('/invitations');
      setInvitationCodes(res.data);
    } catch (err) {
      console.error('Erreur chargement codes:', err);
    }
  };

  const handleGenerateCode = async (e) => {
    e.preventDefault();
    try {
      const res = await api.post('/invitations/generate', newCode);
      setMessage(`Code généré: ${res.data.code}`);
      setNewCode({ role: 'vendeur', expiresInDays: 30 });
      fetchInvitationCodes();
    } catch (err) {
      setMessage('Erreur lors de la génération du code');
    }
  };

  const handleCreateUser = async (e) => {
    e.preventDefault();
    try {
      await api.post('/admin/users', newUser);
      setMessage('Utilisateur créé avec succès');
      setNewUser({ name: '', email: '', password: '', role: 'admin' });
      fetchStats(); // Refresh stats
    } catch (err) {
      setMessage('Erreur lors de la création');
    }
  };

  const handleUserChange = (e) => {
    setNewUser({ ...newUser, [e.target.name]: e.target.value });
  };

  const handleCodeChange = (e) => {
    setNewCode({ ...newCode, [e.target.name]: e.target.value });
  };

  const getRoleBadgeStyle = (role) => {
    const baseStyle = {
      padding: '2px 8px',
      borderRadius: '12px',
      fontSize: '12px',
      fontWeight: 'bold'
    };

    switch (role) {
      case 'vendeur':
        return { ...baseStyle, backgroundColor: '#007bff', color: 'white' };
      case 'livreur':
        return { ...baseStyle, backgroundColor: '#ffc107', color: 'black' };
      default:
        return { ...baseStyle, backgroundColor: '#6c757d', color: 'white' };
    }
  };

  return (
    <div>
      <h2>Administration</h2>

      <section style={styles.section}>
        <h3 style={styles.sectionTitle}>Créer un administrateur</h3>
        <p style={styles.description}>
          Créez de nouveaux comptes administrateur. Pour les vendeurs et livreurs, utilisez le système d'invitations ci-dessous.
        </p>
        <form onSubmit={handleCreateUser} style={styles.form}>
          <input
            name="name"
            placeholder="Nom complet"
            value={newUser.name}
            onChange={handleUserChange}
            style={styles.input}
            required
          />
          <input
            name="email"
            type="email"
            placeholder="Email"
            value={newUser.email}
            onChange={handleUserChange}
            style={styles.input}
            required
          />
          <input
            name="password"
            type="password"
            placeholder="Mot de passe"
            value={newUser.password}
            onChange={handleUserChange}
            style={styles.input}
            required
          />
          <select
            name="role"
            value={newUser.role}
            onChange={handleUserChange}
            style={styles.select}
          >
            <option value="admin">Administrateur</option>
          </select>
          <button type="submit" style={styles.button}>Créer l'utilisateur</button>
        </form>
      </section>

      <section style={styles.section}>
        <h3 style={styles.sectionTitle}>Gérer les codes d'invitation</h3>
        <p style={styles.description}>
          Générez des codes d'invitation pour permettre aux vendeurs et livreurs de s'inscrire.
          Distribuez ces codes aux personnes de confiance qui souhaitent rejoindre la plateforme.
        </p>

        <div style={styles.codeGeneration}>
          <h4>Générer un nouveau code</h4>
          <form onSubmit={handleGenerateCode} style={styles.form}>
            <select
              name="role"
              value={newCode.role}
              onChange={handleCodeChange}
              style={styles.select}
            >
              <option value="vendeur">Vendeur</option>
              <option value="livreur">Livreur</option>
            </select>
            <input
              name="expiresInDays"
              type="number"
              placeholder="Jours d'expiration"
              value={newCode.expiresInDays}
              onChange={handleCodeChange}
              style={styles.input}
              min="1"
              max="365"
            />
            <button type="submit" style={styles.button}>Générer le code</button>
          </form>
        </div>

        <div style={styles.codesList}>
          <h4>Codes d'invitation actifs</h4>
          {invitationCodes.length === 0 ? (
            <p>Aucun code d'invitation généré</p>
          ) : (
            <div style={styles.codesGrid}>
              {invitationCodes.map((code) => (
                <div key={code.id} style={styles.codeCard}>
                  <div style={styles.codeInfo}>
                    <strong>{code.code}</strong>
                    <span style={getRoleBadgeStyle(code.role)}>{code.role}</span>
                  </div>
                  <div style={styles.codeDetails}>
                    <p>Statut: {code.isUsed ? 'Utilisé' : 'Disponible'}</p>
                    {code.expiresAt && (
                      <p>Expire: {new Date(code.expiresAt).toLocaleDateString()}</p>
                    )}
                    {code.user && (
                      <p>Utilisé par: {code.user.name}</p>
                    )}
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </section>

      <section style={styles.section}>
        <h3 style={styles.sectionTitle}>Statistiques</h3>
        {!stats ? (
          <p>Chargement...</p>
        ) : (
          <div style={styles.stats}>
            <div style={styles.statCard}>
              <h4>Utilisateurs</h4>
              <p style={styles.statNumber}>{stats.users}</p>
            </div>
            <div style={styles.statCard}>
              <h4>Produits</h4>
              <p style={styles.statNumber}>{stats.products}</p>
            </div>
            <div style={styles.statCard}>
              <h4>Commandes</h4>
              <p style={styles.statNumber}>{stats.orders}</p>
            </div>
            <div style={styles.statCard}>
              <h4>Livraisons</h4>
              <p style={styles.statNumber}>{stats.deliveries}</p>
            </div>
          </div>
        )}
      </section>
    </div>
  );
};

const styles = {
  section: {
    marginBottom: '30px',
    padding: '20px',
    background: 'white',
    borderRadius: '10px',
    boxShadow: '0 2px 10px rgba(0,0,0,0.1)'
  },
  sectionTitle: {
    margin: '0 0 20px 0',
    color: '#333',
    fontSize: '18px'
  },
  description: {
    margin: '0 0 20px 0',
    color: '#666',
    fontSize: '14px',
    lineHeight: '1.5'
  },
  form: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))',
    gap: '15px',
    alignItems: 'end'
  },
  input: {
    padding: '10px',
    border: '1px solid #ddd',
    borderRadius: '5px',
    fontSize: '14px'
  },
  select: {
    padding: '10px',
    border: '1px solid #ddd',
    borderRadius: '5px',
    background: 'white',
    fontSize: '14px'
  },
  button: {
    padding: '10px 20px',
    background: '#667eea',
    color: 'white',
    border: 'none',
    borderRadius: '5px',
    cursor: 'pointer',
    fontWeight: 'bold'
  },
  message: {
    marginTop: '10px',
    padding: '10px',
    borderRadius: '5px',
    background: '#d4edda',
    color: '#155724',
    border: '1px solid #c3e6cb'
  },
  stats: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(150px, 1fr))',
    gap: '20px'
  },
  statCard: {
    background: 'white',
    padding: '20px',
    borderRadius: '10px',
    boxShadow: '0 2px 10px rgba(0,0,0,0.1)',
    textAlign: 'center'
  },
  statNumber: {
    fontSize: '32px',
    fontWeight: 'bold',
    color: '#667eea',
    margin: '10px 0 0 0'
  },
  codeGeneration: {
    marginBottom: '30px',
    padding: '20px',
    background: 'white',
    borderRadius: '10px',
    boxShadow: '0 2px 10px rgba(0,0,0,0.1)'
  },
  codesList: {
    padding: '20px',
    background: 'white',
    borderRadius: '10px',
    boxShadow: '0 2px 10px rgba(0,0,0,0.1)'
  },
  codesGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fill, minmax(250px, 1fr))',
    gap: '15px',
    marginTop: '15px'
  },
  codeCard: {
    padding: '15px',
    border: '1px solid #ddd',
    borderRadius: '8px',
    background: '#f9f9f9'
  },
  codeInfo: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: '10px'
  },
  codeDetails: {
    fontSize: '14px',
    color: '#666'
  }
};