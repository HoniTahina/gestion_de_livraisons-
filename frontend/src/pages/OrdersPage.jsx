import { useEffect, useState } from 'react';
import api from '../services/api';
import { useAuth } from '../context/AuthContext';

// page des commandes, à améliorer plus tard
export default function OrdersPage() {
  const [orders, setOrders] = useState([]);
  const [message, setMessage] = useState('');
  const { user } = useAuth();

  useEffect(() => {
    fetchOrders();
  }, []);

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
      setMessage(`Commande ${orderId} mise à jour en ${status}`);
      fetchOrders(); // recharger après update
    } catch (err) {
      setMessage("Impossible de mettre à jour le statut");
      console.error('erreur update statut commande:', err);
    }
  };

  return (
    <div>
      <h2>Mes commandes</h2>
      {message && <p>{message}</p>}

      {orders.length === 0 ? (
        <p>Aucune commande.</p>
      ) : (
        orders.map((order) => (
          <div key={order.id} style={styles.card}>
            <p><strong>Commande #{order.id}</strong></p>
            <p>Statut : {order.status}</p>
            <p>Montant : {order.total} €</p>
            <p>Commission : {order.commission ?? 0} €</p>
            <p>Vendeur : {order.vendor?.name || 'Multi-vendeurs'}</p>
            {Array.isArray(order.SubOrders) && order.SubOrders.length > 0 && (
              <div style={styles.subOrders}>
                <strong>Sous-commandes :</strong>
                {order.SubOrders.map((sub) => (
                  <div key={sub.id} style={styles.subOrderItem}>
                    <span>#{sub.id} - {sub.vendor?.name || 'Vendeur'} - {sub.subtotal} €</span>
                    <span>{sub.Delivery?.status || 'Non assignée'}</span>
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
              <button onClick={() => updateStatus(order.id, 'PAID')}>Payer</button>
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
  card: {
    border: '1px solid #ccc',
    padding: '10px',
    borderRadius: '5px',
    marginBottom: '10px'
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