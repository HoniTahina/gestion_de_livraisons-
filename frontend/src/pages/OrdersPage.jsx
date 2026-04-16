import { useEffect, useState } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import api from '../services/api';
import { useAuth } from '../context/AuthContext';

const getOrderStatusLabel = (status) => {
  if (status === 'PENDING') return 'Non payee';
  if (status === 'PAID') return 'Payee';
  if (status === 'SHIPPED') return 'Expediee';
  if (status === 'DELIVERED') return 'Livree';
  return status || 'Inconnu';
};

const getDeliveryStatusLabel = (status) => {
  if (status === 'ASSIGNED') return 'Traitement de livraison';
  if (status === 'PROCESSING') return 'Traitement de livraison';
  if (status === 'IN_TRANSIT') return 'En cours';
  if (status === 'DONE') return 'Livree';
  return status || 'Aucune livraison';
};

// page des commandes, à améliorer plus tard
export default function OrdersPage() {
  const [orders, setOrders] = useState([]);
  const [message, setMessage] = useState('');
  const [showAllOrders, setShowAllOrders] = useState(false);
  const { user } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const createdOrderId = location.state?.createdOrderId;

  useEffect(() => {
    fetchOrders();
  }, []);

  useEffect(() => {
    if (location.state?.message) {
      setMessage(location.state.message);
    }
    if (location.state?.createdOrderId) {
      setShowAllOrders(false);
    }
  }, [location.state]);

  const displayedOrders = showAllOrders || !createdOrderId
    ? orders
    : orders.filter((order) => Number(order.id) === Number(createdOrderId));

  const fetchOrders = async () => {
    try {
      const res = await api.get('/orders');
      setOrders(res.data);
      console.log('commandes chargées:', res.data); // debug
    } catch (err) {
      console.error('erreur chargement commandes:', err);
    }
  };

  const updateStatus = async (orderId, status) => {
    try {
      await api.put(`/orders/${orderId}/status`, { status });
      setMessage(`Commande ${orderId} mise a jour en ${getOrderStatusLabel(status)}`);
      fetchOrders(); // recharger après update
    } catch (err) {
      setMessage("Impossible de mettre à jour le statut");
      console.error('erreur update statut commande:', err);
    }
  };

  const handleGoToPayment = (order) => {
    navigate('/payment', {
      state: {
        existingOrder: order,
      },
    });
  };

  return (
    <div>
      <h2>Mes commandes</h2>
      {message && <p>{message}</p>}

      {createdOrderId && orders.length > 0 && (
        <div style={styles.focusActions}>
          <button
            type="button"
            style={styles.button}
            onClick={() => setShowAllOrders((prev) => !prev)}
          >
            {showAllOrders ? 'Voir uniquement la commande creee' : 'Voir toutes mes commandes'}
          </button>
        </div>
      )}

      {displayedOrders.length === 0 ? (
        <p>Aucune commande.</p>
      ) : (
        displayedOrders.map((order) => (
          <div
            key={order.id}
            style={{
              ...styles.card,
              ...(Number(order.id) === Number(createdOrderId) && !showAllOrders ? styles.focusCard : {}),
            }}
          >
            <p><strong>Commande #{order.id}</strong></p>
            <p>Statut : {getOrderStatusLabel(order.status)}</p>
            <p>Montant : {order.total} €</p>
            <p>Commission : {order.commission ?? 0} €</p>
            <p>Vendeur : {order.vendor?.name || 'Multi-vendeurs'}</p>
            {Array.isArray(order.SubOrders) && order.SubOrders.length > 0 && (
              <div style={styles.subOrders}>
                <strong>Sous-commandes :</strong>
                {order.SubOrders.map((sub) => (
                  <div key={sub.id} style={styles.subOrderItem}>
                    <span>#{sub.id} - {sub.vendor?.name || 'Vendeur'} - {sub.subtotal} €</span>
                    <span>{getDeliveryStatusLabel(sub.Delivery?.status)}</span>
                  </div>
                ))}
              </div>
            )}
            {order.OrderItems?.length > 0 && (
              <div style={styles.items}>
                <strong>Lignes :</strong>
                {order.OrderItems.map((item) => (
                  <div key={item.id} style={styles.item}>
                    <span>{item.quantity} × {item.Product?.name || 'Produit'}</span>
                    <span>{item.price} €</span>
                  </div>
                ))}
              </div>
            )}
            <p>Date : {new Date(order.createdAt).toLocaleString()}</p>
            {user?.role === 'client' && order.status === 'PENDING' && (
              <button onClick={() => handleGoToPayment(order)}>Payer</button>
            )}
            {user?.role === 'admin' && order.status === 'PENDING' && (
              <button onClick={() => updateStatus(order.id, 'PAID')}>Marquer payée</button>
            )}
            {user?.role === 'admin' && order.status === 'PAID' && (
              <button onClick={() => updateStatus(order.id, 'SHIPPED')}>Expédier</button>
            )}
            {user?.role === 'admin' && order.status === 'SHIPPED' && (
              <button onClick={() => updateStatus(order.id, 'DELIVERED')}>Marquer livrée</button>
            )}
          </div>
        ))
      )}
    </div>
  );
}

const styles = {
  focusActions: {
    marginBottom: '10px',
  },
  card: {
    border: '1px solid #ccc',
    padding: '10px',
    borderRadius: '5px',
    marginBottom: '10px'
  },
  focusCard: {
    border: '2px solid #22c55e',
    boxShadow: '0 0 0 3px rgba(34, 197, 94, 0.15)',
  },
  items: {
    marginTop: '8px',
    paddingLeft: '8px',
    borderLeft: '2px solid #ddd'
  },
  subOrders: {
    marginTop: '8px',
    marginBottom: '8px',
    paddingLeft: '8px',
    borderLeft: '2px solid #d8e6ff'
  },
  subOrderItem: {
    display: 'flex',
    justifyContent: 'space-between',
    marginBottom: '3px'
  },
  item: {
    display: 'flex',
    justifyContent: 'space-between',
    marginBottom: '3px'
  }
};