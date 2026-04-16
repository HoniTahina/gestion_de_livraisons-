import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { useCart } from '../context/CartContext';

export default function Layout({ children }) {
  const { user, logout } = useAuth();
  const { cartItemsCount } = useCart();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  const getRoleLabel = (role) => {
    switch (role) {
      case 'client': return 'Client';
      case 'vendeur': return 'Vendeur';
      case 'livreur': return 'Livreur';
      case 'admin': return 'Admin';
      default: return role;
    }
  };

  const getRoleBadgeStyle = (role) => {
    const baseStyle = {
      padding: '2px 8px',
      borderRadius: '12px',
      fontSize: '12px',
      fontWeight: 'bold',
      marginLeft: '8px'
    };

    switch (role) {
      case 'client':
        return { ...baseStyle, backgroundColor: '#28a745', color: 'white' };
      case 'vendeur':
        return { ...baseStyle, backgroundColor: '#007bff', color: 'white' };
      case 'livreur':
        return { ...baseStyle, backgroundColor: '#ffc107', color: 'black' };
      case 'admin':
        return { ...baseStyle, backgroundColor: '#dc3545', color: 'white' };
      default:
        return { ...baseStyle, backgroundColor: '#6c757d', color: 'white' };
    }
  };

  return (
    <div>
      <nav style={styles.nav}>
        <div style={styles.logo}>
          <h1 style={styles.logoText}>🚚 LivraisonPro</h1>
        </div>
        <div style={styles.links}>
          <Link to="/" style={styles.link}>Produits</Link>
          <Link to="/cart" style={styles.link}>
            Panier <span style={styles.cartBadge}>{cartItemsCount}</span>
          </Link>
          <Link to="/orders" style={styles.link}>Commandes</Link>
          <Link to="/deliveries" style={styles.link}>Livraisons</Link>
          {user && <Link to="/profile" style={styles.link}>Profil</Link>}
          {user?.role === 'admin' && <Link to="/admin" style={styles.link}>Admin</Link>}
        </div>

        <div style={styles.userSection}>
          {user ? (
            <>
              <div style={styles.userInfo}>
                <span>{user.name}</span>
                <span style={getRoleBadgeStyle(user.role)}>{getRoleLabel(user.role)}</span>
              </div>
              <button onClick={handleLogout} style={styles.logoutBtn}>Déconnexion</button>
            </>
          ) : (
            <>
              <Link to="/login" style={styles.authLink}>Connexion</Link>
              <Link to="/register" style={styles.authLinkPrimary}>Inscription</Link>
            </>
          )}
        </div>
      </nav>

      <main style={styles.main}>{children}</main>
    </div>
  );
}

const styles = {
  nav: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '15px 25px',
    background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
    color: 'white',
    boxShadow: '0 2px 10px rgba(0,0,0,0.1)'
  },
  logo: {
    flex: 1
  },
  logoText: {
    margin: 0,
    fontSize: '24px',
    fontWeight: 'bold',
    color: 'white'
  },
  links: {
    display: 'flex',
    gap: '20px',
    flex: 2,
    justifyContent: 'center'
  },
  link: {
    color: 'white',
    textDecoration: 'none',
    fontWeight: '500',
    padding: '8px 12px',
    borderRadius: '5px',
    transition: 'background-color 0.3s',
    ':hover': {
      backgroundColor: 'rgba(255,255,255,0.1)'
    }
  },
  cartBadge: {
    marginLeft: '6px',
    backgroundColor: '#22c55e',
    color: 'white',
    borderRadius: '999px',
    padding: '1px 7px',
    fontSize: '12px',
    fontWeight: '700'
  },
  userSection: {
    display: 'flex',
    alignItems: 'center',
    gap: '15px',
    flex: 1,
    justifyContent: 'flex-end'
  },
  userInfo: {
    display: 'flex',
    alignItems: 'center',
    fontWeight: '500'
  },
  logoutBtn: {
    background: 'rgba(255,255,255,0.2)',
    color: 'white',
    border: '1px solid white',
    padding: '6px 12px',
    borderRadius: '5px',
    cursor: 'pointer',
    fontSize: '14px',
    transition: 'background-color 0.3s'
  },
  authLink: {
    color: 'white',
    textDecoration: 'none',
    fontWeight: '500',
    padding: '6px 12px',
    borderRadius: '5px',
    transition: 'background-color 0.3s'
  },
  authLinkPrimary: {
    background: 'white',
    color: '#667eea',
    textDecoration: 'none',
    fontWeight: 'bold',
    padding: '8px 16px',
    borderRadius: '5px',
    transition: 'transform 0.2s'
  },
  main: {
    padding: '20px',
    minHeight: 'calc(100vh - 80px)',
    backgroundColor: '#f8f9fa'
  }
};