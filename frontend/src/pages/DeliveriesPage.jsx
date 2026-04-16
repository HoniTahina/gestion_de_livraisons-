import { useEffect, useState } from 'react';
import api from '../services/api';
import { useAuth } from '../context/AuthContext';

// TODO: ajouter une pagination si y'a trop de livraisons
// page pour gérer les livraisons, un peu brouillon mais ça marche
export default function DeliveriesPage() {
  const [deliveries, setDeliveries] = useState([]);
  const [drivers, setDrivers] = useState([]);
  const [orders, setOrders] = useState([]);
  const [assignData, setAssignData] = useState({ orderId: '', deliveryPersonId: '' });
  const [message, setMessage] = useState('');
  const { user } = useAuth();

  useEffect(() => {
    fetchDeliveries();
    if (user?.role === 'admin') {
      fetchDrivers();
      fetchOrders();
    }
  }, [user]);

  useEffect(() => {
    const baseUrl = (import.meta.env.VITE_API_URL || '').replace(/\/$/, '');
    if (!baseUrl) return;

    const handlePayload = (raw) => {
      try {
        const payload = typeof raw === 'string' ? JSON.parse(raw) : raw;
        if (payload?.eventType?.startsWith('delivery.')) {
          fetchDeliveries();
          if (user?.role === 'admin') {
            fetchOrders();
          }
        }
      } catch (err) {
        console.error('Erreur parsing realtime:', err);
      }
    };

    let ws;
    let events;

    try {
      const wsUrl = baseUrl.replace(/^http/i, 'ws');
      ws = new WebSocket(`${wsUrl}/ws`);
      ws.onmessage = (event) => handlePayload(event.data);
      ws.onerror = () => {
        if (!events) {
          events = new EventSource(`${baseUrl}/events`);
          events.onmessage = (event) => handlePayload(event.data);
        }
      };
    } catch (err) {
      events = new EventSource(`${baseUrl}/events`);
      events.onmessage = (event) => handlePayload(event.data);
    }

    return () => {
      if (ws) ws.close();
      if (events) events.close();
    };
  }, [user]);

  const fetchDeliveries = async () => {
    try {
      const res = await api.get('/deliveries');
      setDeliveries(res.data);
      console.log('livraisons chargées:', res.data); // pour debug
    } catch (err) {
      console.error('erreur chargement livraisons:', err);
    }
  };

  const fetchDrivers = async () => {
    try {
      const res = await api.get('/users');
      setDrivers(res.data.filter((u) => u.role === 'livreur'));
    } catch (err) {
      console.error(err);
    }
  };

  const fetchOrders = async () => {
    try {
      const res = await api.get('/orders');
      setOrders(
        res.data.filter(
          (order) =>
            order.status === 'PAID' &&
            Array.isArray(order.SubOrders) &&
            order.SubOrders.some((sub) => !sub.Delivery)
        )
      );
    } catch (err) {
      console.error(err);
    }
  };

  const updateStatus = async (id, status) => {
    try {
      await api.put(`/deliveries/${id}/status`, { status });
      setMessage(`Livraison ${id} mise à jour en ${status}`);
      fetchDeliveries(); // recharger après update
    } catch (err) {
      setMessage('Impossible de mettre à jour le statut');
      console.error('erreur update statut livraison:', err);
    }
  };

  const getNextStatus = (status) => {
    if (status === 'ASSIGNED') return 'IN_TRANSIT';
    if (status === 'IN_TRANSIT') return 'DONE';
    return null;
  };

  const handleAssign = async (e) => {
    e.preventDefault();
    try {
      await api.post('/deliveries/assign', {
        orderId: Number(assignData.orderId),
        deliveryPersonId: Number(assignData.deliveryPersonId),
      });
      setMessage('Livraison assignée avec succès');
      setAssignData({ orderId: '', deliveryPersonId: '' });
      fetchDeliveries();
      fetchOrders(); // mettre à jour les commandes dispo
    } catch (err) {
      setMessage('Impossible d’assigner la livraison');
      console.error('erreur assignation livraison:', err);
    }
  };

  return (
    <div>
      <h2>Livraisons</h2>
      {message && <p>{message}</p>}

      {user?.role === 'admin' && (
        <section style={styles.assignSection}>
          <h3>Assigner une livraison</h3>
          <form onSubmit={handleAssign} style={styles.form}>
            <select
              value={assignData.orderId}
              onChange={(e) => setAssignData({ ...assignData, orderId: e.target.value })}
            >
              <option value="">Sélectionner une commande</option>
              {orders.map((order) => (
                <option key={order.id} value={order.id}>
                  #{order.id} - {order.SubOrders?.length || 0} sous-commandes - {order.total} €
                </option>
              ))}
            </select>
            <select
              value={assignData.deliveryPersonId}
              onChange={(e) => setAssignData({ ...assignData, deliveryPersonId: e.target.value })}
            >
              <option value="">Sélectionner un livreur</option>
              {drivers.map((driver) => (
                <option key={driver.id} value={driver.id}>
                  {driver.name}
                </option>
              ))}
            </select>
            <button type="submit">Assigner</button>
          </form>
        </section>
      )}

      {deliveries.length === 0 ? (
        <p>Aucune livraison.</p>
      ) : (
        deliveries.map((delivery) => (
          <div key={delivery.id} style={styles.card}>
            <p><strong>Livraison #{delivery.id}</strong></p>
            <p>Commande : {delivery.SubOrder?.Order?.id || 'N/A'}</p>
            <p>Sous-commande : {delivery.SubOrder?.id || 'N/A'}</p>
            <p>Livreur : {delivery.deliveryPerson?.name || 'Non attribué'}</p>
            <p>Statut : {delivery.status}</p>
            {delivery.trackingToken && <p>Tracking : {delivery.trackingToken}</p>}
            {(user?.role === 'admin' || user?.role === 'livreur') && getNextStatus(delivery.status) && (
              <button onClick={() => updateStatus(delivery.id, getNextStatus(delivery.status))}>
                {delivery.status === 'ASSIGNED' ? 'Passer en transport' : 'Marquer terminée'}
              </button>
            )}
          </div>
        ))
      )}
    </div>
  );
}

const styles = {
  assignSection: {
    marginBottom: '20px',
    padding: '10px',
    border: '1px solid #ccc',
    borderRadius: '5px',
    backgroundColor: '#f9f9f9'
  },
  form: {
    display: 'flex',
    flexDirection: 'column',
    gap: '8px',
    maxWidth: '400px'
  },
  card: {
    border: '1px solid #ccc',
    padding: '10px',
    borderRadius: '5px',
    marginBottom: '10px'
  }
};