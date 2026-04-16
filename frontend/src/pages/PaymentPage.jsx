import { useMemo, useState } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import { useCart } from '../context/CartContext';
import { useAuth } from '../context/AuthContext';
import api from '../services/api';

export default function PaymentPage() {
  const { cart, total, clearCart } = useCart();
  const { user } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const [paymentMethod, setPaymentMethod] = useState('card');
  const [loading, setLoading] = useState(false);
  const [processingMessage, setProcessingMessage] = useState('');
  const paypalBaseUrl = import.meta.env.VITE_PAYPAL_URL || 'https://www.paypal.com/signin';
  const existingOrder = location.state?.existingOrder || null;
  const [cardInfo, setCardInfo] = useState({
    number: '',
    expiry: '',
    cvv: '',
    name: ''
  });

  const isExistingOrderPayment = Boolean(existingOrder?.id);
  const orderItems = useMemo(() => {
    if (isExistingOrderPayment) {
      return Array.isArray(existingOrder?.OrderItems) ? existingOrder.OrderItems : [];
    }

    return cart;
  }, [cart, existingOrder, isExistingOrderPayment]);

  const payableTotal = useMemo(() => {
    if (isExistingOrderPayment) {
      return Number(existingOrder?.total || 0);
    }

    return total;
  }, [existingOrder, isExistingOrderPayment, total]);

  const detectCardType = (rawNumber) => {
    if (!rawNumber) return 'Inconnue';
    if (/^4/.test(rawNumber)) return 'Visa';
    if (/^(5[1-5]|2(2[2-9]|[3-6]\d|7[01]))/.test(rawNumber)) return 'Mastercard';
    if (/^3[47]/.test(rawNumber)) return 'American Express';
    if (/^6(011|5)/.test(rawNumber)) return 'Discover';
    if (/^(50|56|57|58|6)/.test(rawNumber)) return 'Maestro';
    return 'Carte bancaire';
  };

  const cardType = useMemo(() => {
    const rawNumber = cardInfo.number.replace(/\D/g, '');
    return detectCardType(rawNumber);
  }, [cardInfo.number]);

  const redirectToPaypal = () => {
    setProcessingMessage('Redirection vers PayPal...');
    window.location.href = paypalBaseUrl;
  };

  const handlePaymentMethodChange = (value) => {
    setPaymentMethod(value);
    if (value === 'paypal') {
      redirectToPaypal();
    }
  };

  const handleCardChange = (e) => {
    const { name, value } = e.target;

    if (name === 'number') {
      const raw = value.replace(/\D/g, '').slice(0, 19);
      const detectedType = detectCardType(raw);

      let formattedNumber;
      if (detectedType === 'American Express') {
        const p1 = raw.slice(0, 4);
        const p2 = raw.slice(4, 10);
        const p3 = raw.slice(10, 15);
        formattedNumber = [p1, p2, p3].filter(Boolean).join(' ');
      } else {
        formattedNumber = raw.match(/.{1,4}/g)?.join(' ') || '';
      }

      setCardInfo((prev) => ({ ...prev, number: formattedNumber }));
      return;
    }

    if (name === 'expiry') {
      const raw = value.replace(/\D/g, '').slice(0, 4);
      const formattedExpiry = raw.length > 2 ? `${raw.slice(0, 2)}/${raw.slice(2)}` : raw;
      setCardInfo((prev) => ({ ...prev, expiry: formattedExpiry }));
      return;
    }

    if (name === 'cvv') {
      const raw = value.replace(/\D/g, '');
      const maxLength = cardType === 'American Express' ? 4 : 3;
      setCardInfo((prev) => ({ ...prev, cvv: raw.slice(0, maxLength) }));
      return;
    }

    setCardInfo((prev) => ({ ...prev, [name]: value }));
  };

  const handlePayment = async () => {
    if (!orderItems.length) {
      alert('Votre panier est vide');
      return;
    }

    if (paymentMethod === 'paypal') {
      redirectToPaypal();
      return;
    }

    const rawCardNumber = cardInfo.number.replace(/\D/g, '');
    if (!rawCardNumber || rawCardNumber.length < 13 || !cardInfo.expiry || !cardInfo.cvv || !cardInfo.name.trim()) {
      alert('Veuillez compléter correctement les informations de la carte.');
      return;
    }

    setLoading(true);
    setProcessingMessage('Redirection vers la page securisee de votre banque...');
    try {
      let order = existingOrder;

      if (!isExistingOrderPayment) {
        const orderData = {
          items: cart.map(item => ({
            productId: item.id,
            quantity: item.quantity,
            price: item.price
          }))
        };

        const response = await api.post('/orders', orderData);
        order = response.data;
      }

      // Simulation d'un flux standard banque/3DS
      await new Promise(resolve => setTimeout(resolve, 2000));

      // Marquer la commande comme payée
      await api.put(`/orders/${order.id}/status`, { status: 'PAID' });

      if (!isExistingOrderPayment) {
        clearCart();
      }

      // Rediriger vers la page de suivi de livraison
      navigate('/deliveries', {
        state: {
          message: 'Paiement confirme. Votre livraison est en cours de traitement.',
          orderId: order.id
        }
      });

    } catch (err) {
      console.error('Erreur lors du paiement:', err);
      alert('Erreur lors du paiement. Veuillez réessayer.');
    } finally {
      setLoading(false);
    }
  };

  if (!orderItems.length) {
    return (
      <div style={styles.emptyContainer}>
        <h2>Aucun paiement en attente</h2>
        <p>Retournez a la boutique ou a vos commandes.</p>
        <button onClick={() => navigate('/')} style={styles.backButton}>
          Retour à la boutique
        </button>
      </div>
    );
  }

  return (
    <div style={styles.container}>
      <h2 style={styles.title}>Paiement</h2>

      <div style={styles.content}>
        {/* Récapitulatif de commande */}
        <div style={styles.orderSummary}>
          <h3>{isExistingOrderPayment ? `Paiement de la commande #${existingOrder.id}` : 'Recapitulatif de votre commande'}</h3>
          <div style={styles.items}>
            {orderItems.map((item) => (
              <div key={item.id} style={styles.item}>
                <div style={styles.itemInfo}>
                  <h4>{item.Product?.name || item.name}</h4>
                  <p>Quantité: {item.quantity}</p>
                  <p>Vendeur: {item.Product?.vendor?.name || item.vendor?.name || 'N/A'}</p>
                </div>
                <div style={styles.itemPrice}>
                  {(Number(item.price || 0) * Number(item.quantity || 0)).toFixed(2)} €
                </div>
              </div>
            ))}
          </div>
          <div style={styles.total}>
            <strong>Total: {payableTotal.toFixed(2)} €</strong>
          </div>
        </div>

        {/* Méthode de paiement */}
        <div style={styles.paymentSection}>
          <h3>Méthode de paiement</h3>

          <div style={styles.paymentMethods}>
            <label style={styles.methodOption}>
              <input
                type="radio"
                value="card"
                checked={paymentMethod === 'card'}
                onChange={(e) => handlePaymentMethodChange(e.target.value)}
              />
              <span>Carte bancaire</span>
            </label>
            <label style={styles.methodOption}>
              <input
                type="radio"
                value="paypal"
                checked={paymentMethod === 'paypal'}
                onChange={(e) => handlePaymentMethodChange(e.target.value)}
              />
              <span>PayPal</span>
            </label>
          </div>

          {paymentMethod === 'card' && (
            <div style={styles.cardForm}>
              <div style={styles.formGroup}>
                <label style={styles.label}>Numéro de carte</label>
                <input
                  type="text"
                  name="number"
                  placeholder="1234 5678 9012 3456"
                  value={cardInfo.number}
                  onChange={handleCardChange}
                  style={styles.input}
                  maxLength="19"
                />
                <small style={styles.cardType}>Type detecte: {cardType}</small>
              </div>
              <div style={styles.formRow}>
                <div style={styles.formGroup}>
                  <label style={styles.label}>Date d'expiration</label>
                  <input
                    type="text"
                    name="expiry"
                    placeholder="MM/AA"
                    value={cardInfo.expiry}
                    onChange={handleCardChange}
                    style={styles.input}
                    maxLength="5"
                  />
                </div>
                <div style={styles.formGroup}>
                  <label style={styles.label}>CVV</label>
                  <input
                    type="text"
                    name="cvv"
                    placeholder="123"
                    value={cardInfo.cvv}
                    onChange={handleCardChange}
                    style={styles.input}
                    maxLength="3"
                  />
                </div>
              </div>
              <div style={styles.formGroup}>
                <label style={styles.label}>Nom sur la carte</label>
                <input
                  type="text"
                  name="name"
                  placeholder="John Doe"
                  value={cardInfo.name}
                  onChange={handleCardChange}
                  style={styles.input}
                />
              </div>
            </div>
          )}

          {paymentMethod === 'paypal' && (
            <div style={styles.paypalInfo}>
              <p>Vous allez etre redirige vers PayPal pour finaliser le paiement.</p>
            </div>
          )}

          {paymentMethod === 'card' && (
            <div style={styles.paymentNotice}>
              <p>Apres "Proceder au paiement", vous serez redirige vers une page bancaire securisee (3D Secure) standard.</p>
            </div>
          )}

          {processingMessage && <p style={styles.processingText}>{processingMessage}</p>}

          <button
            onClick={handlePayment}
            disabled={loading}
            style={styles.payButton}
          >
            {loading ? 'Traitement du paiement...' : `Proceder au paiement - ${payableTotal.toFixed(2)} €`}
          </button>
        </div>
      </div>
    </div>
  );
}

const styles = {
  container: {
    maxWidth: '1200px',
    margin: '0 auto',
    padding: '20px'
  },
  title: {
    textAlign: 'center',
    marginBottom: '30px',
    color: '#333'
  },
  content: {
    display: 'grid',
    gridTemplateColumns: '1fr 1fr',
    gap: '40px',
    '@media (max-width: 768px)': {
      gridTemplateColumns: '1fr'
    }
  },
  orderSummary: {
    background: 'white',
    padding: '20px',
    borderRadius: '10px',
    boxShadow: '0 2px 10px rgba(0,0,0,0.1)'
  },
  items: {
    marginBottom: '20px'
  },
  item: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '15px 0',
    borderBottom: '1px solid #eee'
  },
  itemInfo: {
    flex: 1
  },
  itemPrice: {
    fontWeight: 'bold',
    color: '#667eea'
  },
  total: {
    textAlign: 'right',
    fontSize: '18px',
    color: '#28a745',
    padding: '15px 0',
    borderTop: '2px solid #eee'
  },
  paymentSection: {
    background: 'white',
    padding: '20px',
    borderRadius: '10px',
    boxShadow: '0 2px 10px rgba(0,0,0,0.1)'
  },
  paymentMethods: {
    display: 'flex',
    flexDirection: 'column',
    gap: '10px',
    marginBottom: '20px'
  },
  methodOption: {
    display: 'flex',
    alignItems: 'center',
    gap: '10px',
    padding: '10px',
    border: '2px solid #e1e5e9',
    borderRadius: '8px',
    cursor: 'pointer',
    transition: 'border-color 0.3s'
  },
  cardForm: {
    marginTop: '20px'
  },
  formRow: {
    display: 'grid',
    gridTemplateColumns: '1fr 1fr',
    gap: '15px',
    marginBottom: '15px'
  },
  formGroup: {
    marginBottom: '15px'
  },
  label: {
    display: 'block',
    marginBottom: '5px',
    fontWeight: '500',
    color: '#555'
  },
  input: {
    width: '100%',
    padding: '12px',
    border: '2px solid #e1e5e9',
    borderRadius: '8px',
    fontSize: '16px',
    transition: 'border-color 0.3s',
    boxSizing: 'border-box'
  },
  cardType: {
    display: 'block',
    marginTop: '6px',
    color: '#334155',
    fontSize: '13px',
    fontWeight: '600'
  },
  paypalInfo: {
    padding: '20px',
    background: '#fff9c4',
    borderRadius: '8px',
    marginTop: '20px'
  },
  paymentNotice: {
    padding: '20px',
    background: '#eef2ff',
    borderRadius: '8px',
    marginTop: '20px'
  },
  processingText: {
    marginTop: '12px',
    color: '#0f766e',
    fontWeight: '600'
  },
  payButton: {
    width: '100%',
    padding: '15px',
    background: 'linear-gradient(135deg, #28a745 0%, #20c997 100%)',
    color: 'white',
    border: 'none',
    borderRadius: '8px',
    fontSize: '18px',
    fontWeight: 'bold',
    cursor: 'pointer',
    transition: 'transform 0.2s',
    marginTop: '20px',
    ':hover': {
      transform: 'translateY(-2px)'
    },
    ':disabled': {
      background: '#ccc',
      cursor: 'not-allowed',
      transform: 'none'
    }
  },
  emptyContainer: {
    textAlign: 'center',
    padding: '50px 20px'
  },
  backButton: {
    padding: '12px 24px',
    background: '#667eea',
    color: 'white',
    border: 'none',
    borderRadius: '8px',
    fontSize: '16px',
    cursor: 'pointer',
    marginTop: '20px'
  }
};