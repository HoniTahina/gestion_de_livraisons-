import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../services/api';
import { useCart } from '../context/CartContext';

export default function CartPage() {
  const { cart, removeFromCart, increaseQuantity, decreaseQuantity, clearCart, total } = useCart();
  const [message, setMessage] = useState('');
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const handleNext = async () => {
    if (cart.length === 0) {
      setMessage('Votre panier est vide');
      return;
    }

    setLoading(true);

    try {
      const orderData = {
        items: cart.map((item) => ({
          productId: item.id,
          quantity: item.quantity,
          price: item.price,
        })),
      };

      const response = await api.post('/orders', orderData);
      const order = response.data;

      clearCart();
      navigate('/orders', {
        state: {
          message: `Commande #${order.id} creee. Verifiez-la puis passez au paiement.`,
          createdOrderId: order.id,
        },
      });
    } catch (err) {
      console.error('erreur creation commande:', err);
      const apiMessage = err.response?.data?.error;
      setMessage(apiMessage || 'Impossible de creer la commande');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={styles.container}>
      <h2 style={styles.title}>Votre Panier</h2>

      {cart.length === 0 ? (
        <div style={styles.emptyCart}>
          <p style={styles.emptyText}>Votre panier est vide.</p>
          <p style={styles.emptySubtext}>Ajoutez des produits depuis la boutique !</p>
        </div>
      ) : (
        <>
          <div style={styles.items}>
            {cart.map((item) => (
              <div key={item.id} style={styles.item}>
                <button
                  type="button"
                  onClick={() => removeFromCart(item.id)}
                  style={styles.closeButton}
                  aria-label={`Supprimer ${item.name} du panier`}
                  title="Supprimer"
                >
                  ×
                </button>
                <div style={styles.itemInfo}>
                  <h3 style={styles.itemName}>{item.name}</h3>
                  <div style={styles.quantityRow}>
                    <span style={styles.itemDetails}>Quantité:</span>
                    <button
                      type="button"
                      onClick={() => decreaseQuantity(item.id)}
                      style={styles.qtyButton}
                    >
                      -
                    </button>
                    <span style={styles.qtyValue}>{item.quantity}</span>
                    <button
                      type="button"
                      onClick={() => increaseQuantity(item.id)}
                      style={styles.qtyButton}
                    >
                      +
                    </button>
                    <span style={styles.itemDetails}>| Prix unitaire: {item.price} €</span>
                  </div>
                  <p style={styles.itemVendor}>Vendeur: {item.vendor?.name || 'N/A'}</p>
                </div>
                <div style={styles.itemActions}>
                  <span style={styles.itemTotal}>
                    {(item.price * item.quantity).toFixed(2)} €
                  </span>
                  <button
                    type="button"
                    onClick={() => removeFromCart(item.id)}
                    style={styles.removeButton}
                  >
                    Supprimer
                  </button>
                </div>
              </div>
            ))}
          </div>

          <div style={styles.summary}>
            <div style={styles.total}>
              <span>Total de la commande:</span>
              <span style={styles.totalAmount}>{total.toFixed(2)} €</span>
            </div>
            <button onClick={handleNext} style={styles.payButton} disabled={loading}>
              {loading ? 'Creation de la commande...' : 'Suivant'}
            </button>
          </div>
        </>
      )}

      {message && <p style={message.includes('succès') ? styles.successMessage : styles.errorMessage}>{message}</p>}
    </div>
  );
}

const styles = {
  container: {
    maxWidth: '800px',
    margin: '0 auto',
    padding: '20px'
  },
  title: {
    textAlign: 'center',
    marginBottom: '30px',
    color: '#333',
    fontSize: '28px'
  },
  emptyCart: {
    textAlign: 'center',
    padding: '50px 20px',
    background: 'white',
    borderRadius: '10px',
    boxShadow: '0 2px 10px rgba(0,0,0,0.1)'
  },
  emptyText: {
    fontSize: '18px',
    color: '#666',
    margin: '0 0 10px 0'
  },
  emptySubtext: {
    color: '#999',
    margin: '0'
  },
  items: {
    marginBottom: '30px'
  },
  item: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    position: 'relative',
    background: 'white',
    padding: '20px',
    marginBottom: '15px',
    borderRadius: '10px',
    boxShadow: '0 2px 10px rgba(0,0,0,0.1)',
    transition: 'transform 0.2s'
  },
  itemInfo: {
    flex: 1
  },
  itemName: {
    margin: '0 0 8px 0',
    color: '#333',
    fontSize: '18px'
  },
  itemDetails: {
    margin: '0 0 5px 0',
    color: '#666',
    fontSize: '14px'
  },
  quantityRow: {
    display: 'flex',
    alignItems: 'center',
    gap: '8px',
    marginBottom: '5px',
    flexWrap: 'wrap'
  },
  qtyButton: {
    width: '28px',
    height: '28px',
    border: '1px solid #cfd4dc',
    borderRadius: '6px',
    background: '#fff',
    color: '#333',
    cursor: 'pointer',
    fontWeight: 'bold'
  },
  qtyValue: {
    minWidth: '20px',
    textAlign: 'center',
    fontWeight: 'bold',
    color: '#333'
  },
  itemVendor: {
    margin: '0',
    color: '#999',
    fontSize: '12px'
  },
  itemActions: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'flex-end',
    gap: '10px'
  },
  closeButton: {
    position: 'absolute',
    top: '8px',
    right: '10px',
    width: '28px',
    height: '28px',
    padding: 0,
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: '50%',
    border: '1px solid #e5e7eb',
    background: '#fff',
    color: '#dc3545',
    fontSize: '20px',
    lineHeight: 1,
    cursor: 'pointer'
  },
  itemTotal: {
    fontSize: '18px',
    fontWeight: 'bold',
    color: '#667eea'
  },
  removeButton: {
    padding: '6px 12px',
    background: '#dc3545',
    color: 'white',
    border: 'none',
    borderRadius: '5px',
    cursor: 'pointer',
    fontSize: '12px',
    transition: 'background-color 0.3s'
  },
  summary: {
    background: 'white',
    padding: '25px',
    borderRadius: '10px',
    boxShadow: '0 2px 10px rgba(0,0,0,0.1)',
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center'
  },
  total: {
    display: 'flex',
    flexDirection: 'column',
    gap: '5px'
  },
  totalAmount: {
    fontSize: '24px',
    fontWeight: 'bold',
    color: '#28a745'
  },
  payButton: {
    padding: '15px 30px',
    background: 'linear-gradient(135deg, #28a745 0%, #20c997 100%)',
    color: 'white',
    border: 'none',
    borderRadius: '8px',
    fontSize: '18px',
    fontWeight: 'bold',
    cursor: 'pointer',
    transition: 'transform 0.2s',
    ':hover': {
      transform: 'translateY(-2px)'
    }
  },
  successMessage: {
    color: '#28a745',
    textAlign: 'center',
    fontWeight: 'bold',
    marginTop: '20px'
  },
  errorMessage: {
    color: '#dc3545',
    textAlign: 'center',
    fontWeight: 'bold',
    marginTop: '20px'
  }
};