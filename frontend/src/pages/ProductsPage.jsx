import { useEffect, useState } from 'react';
import api from '../services/api';
import { useAuth } from '../context/AuthContext';
import { useCart } from '../context/CartContext';

export default function ProductsPage() {
  const [products, setProducts] = useState([]);
  const [category, setCategory] = useState('');
  const [error, setError] = useState('');
  const [productForm, setProductForm] = useState({
    name: '',
    price: '',
    stock: '',
    category: '',
  });
  const [message, setMessage] = useState('');
  const [editingId, setEditingId] = useState(null);
  const [editForm, setEditForm] = useState({ name: '', price: '', stock: '', category: '' });
  const { addToCart, cartItemsCount, cart } = useCart();
  const { user } = useAuth();

  const getQuantityInCart = (productId) => {
    const entry = cart.find((item) => String(item.id) === String(productId));
    return entry ? entry.quantity : 0;
  };

  useEffect(() => {
    fetchProducts();
  }, []);

  const fetchProducts = async () => {
    try {
      const res = await api.get('/products');
      setProducts(res.data);
    } catch (err) {
      setError('Impossible de charger les produits');
    }
  };

  const handleChange = (e) => {
    setProductForm({ ...productForm, [e.target.name]: e.target.value });
  };

  const handleCreateProduct = async (e) => {
    e.preventDefault();
    try {
      await api.post('/products', {
        name: productForm.name,
        price: Number(productForm.price),
        stock: Number(productForm.stock),
        category: productForm.category,
      });
      setMessage('Produit ajouté avec succès');
      setProductForm({ name: '', price: '', stock: '', category: '' });
      fetchProducts();
    } catch (err) {
      setMessage('Impossible d’ajouter le produit');
    }
  };

  const startEdit = (product) => {
    setEditingId(product.id);
    setEditForm({
      name: product.name,
      price: String(product.price),
      stock: String(product.stock),
      category: product.category,
    });
  };

  const saveEdit = async () => {
    try {
      await api.put(`/products/${editingId}`, {
        name: editForm.name,
        price: Number(editForm.price),
        stock: Number(editForm.stock),
        category: editForm.category,
      });
      setMessage('Produit modifie avec succes');
      setEditingId(null);
      fetchProducts();
    } catch (err) {
      setMessage(err.response?.data?.error || 'Impossible de modifier le produit');
    }
  };

  const filteredProducts = category
    ? products.filter((p) => p.category === category)
    : products;

  const categories = [...new Set(products.map((p) => p.category))];

  return (
    <div>
      <div style={styles.header}>
        <h2 style={styles.title}>Bienvenue sur LivraisonPro</h2>
        <p style={styles.subtitle}>Découvrez nos produits et commandez en toute simplicité</p>
        <p style={styles.cartHint}>Articles dans votre panier: {cartItemsCount}</p>
      </div>

      {user?.role === 'vendeur' || user?.role === 'admin' ? (
        <section style={styles.formSection}>
          <h3 style={styles.sectionTitle}>Ajouter un produit</h3>
          <form onSubmit={handleCreateProduct} style={styles.form}>
            <input name="name" placeholder="Nom du produit" value={productForm.name} onChange={handleChange} style={styles.input} />
            <input name="price" placeholder="Prix (€)" type="number" step="0.01" value={productForm.price} onChange={handleChange} style={styles.input} />
            <input name="stock" placeholder="Stock" type="number" value={productForm.stock} onChange={handleChange} style={styles.input} />
            <input name="category" placeholder="Catégorie" value={productForm.category} onChange={handleChange} style={styles.input} />
            <button type="submit" style={styles.button}>Créer le produit</button>
          </form>
          {message && <p style={styles.message}>{message}</p>}
        </section>
      ) : null}

      <div style={styles.filters}>
        <select value={category} onChange={(e) => setCategory(e.target.value)} style={styles.select}>
          <option value="">Toutes les catégories</option>
          {categories.map((cat, index) => (
            <option key={index} value={cat}>{cat}</option>
          ))}
        </select>
      </div>

      {error && <p style={styles.error}>{error}</p>}

      <div style={styles.grid}>
        {filteredProducts.map((product) => (
          <div key={product.id} style={styles.card}>
            {getQuantityInCart(product.id) > 0 && (
              <div style={styles.inCartBadge}>Dans le panier: {getQuantityInCart(product.id)}</div>
            )}
            {editingId === product.id ? (
              <div style={styles.editBox}>
                <input
                  style={styles.input}
                  value={editForm.name}
                  onChange={(e) => setEditForm({ ...editForm, name: e.target.value })}
                />
                <input
                  style={styles.input}
                  type="number"
                  step="0.01"
                  value={editForm.price}
                  onChange={(e) => setEditForm({ ...editForm, price: e.target.value })}
                />
                <input
                  style={styles.input}
                  type="number"
                  value={editForm.stock}
                  onChange={(e) => setEditForm({ ...editForm, stock: e.target.value })}
                />
                <input
                  style={styles.input}
                  value={editForm.category}
                  onChange={(e) => setEditForm({ ...editForm, category: e.target.value })}
                />
              </div>
            ) : (
              <>
                <h3 style={styles.productName}>{product.name}</h3>
                <p style={styles.productPrice}>{product.price} €</p>
                <p style={styles.productStock}>Stock: {product.stock}</p>
                <p style={styles.productCategory}>Catégorie: {product.category}</p>
              </>
            )}
            <p style={styles.productVendor}>Vendeur: {product.vendor?.name || 'N/A'}</p>
            <button
              type="button"
              onClick={() => addToCart(product)}
              style={styles.addButton}
              disabled={product.stock === 0}
            >
              {product.stock === 0 ? 'Rupture' : `Ajouter au panier${getQuantityInCart(product.id) > 0 ? ` (${getQuantityInCart(product.id)})` : ''}`}
            </button>
            {(user?.role === 'admin' || user?.id === product.vendorId) && (
              editingId === product.id ? (
                <div style={styles.editActions}>
                  <button type="button" onClick={saveEdit} style={styles.button}>Enregistrer</button>
                  <button type="button" onClick={() => setEditingId(null)} style={styles.removeButton}>Annuler</button>
                </div>
              ) : (
                <button type="button" onClick={() => startEdit(product)} style={styles.button}>Modifier</button>
              )
            )}
          </div>
        ))}
      </div>
    </div>
  );
}

const styles = {
  header: {
    textAlign: 'center',
    marginBottom: '30px',
    padding: '20px',
    background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
    color: 'white',
    borderRadius: '10px'
  },
  title: {
    margin: '0 0 10px 0',
    fontSize: '32px',
    fontWeight: 'bold'
  },
  subtitle: {
    margin: '0',
    fontSize: '18px',
    opacity: '0.9'
  },
  cartHint: {
    margin: '12px 0 0 0',
    fontSize: '14px',
    fontWeight: '600',
    opacity: '0.95'
  },
  formSection: {
    marginBottom: '30px',
    padding: '20px',
    background: 'white',
    borderRadius: '10px',
    boxShadow: '0 2px 10px rgba(0,0,0,0.1)'
  },
  sectionTitle: {
    margin: '0 0 20px 0',
    color: '#333'
  },
  form: {
    display: 'flex',
    flexWrap: 'wrap',
    gap: '10px',
    alignItems: 'center'
  },
  input: {
    padding: '10px',
    border: '1px solid #ddd',
    borderRadius: '5px',
    flex: '1 1 200px'
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
    color: 'green'
  },
  filters: {
    marginBottom: '20px'
  },
  select: {
    padding: '10px',
    border: '1px solid #ddd',
    borderRadius: '5px',
    background: 'white'
  },
  error: {
    color: 'red',
    marginBottom: '20px'
  },
  grid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fill, minmax(250px, 1fr))',
    gap: '20px'
  },
  card: {
    position: 'relative',
    background: 'white',
    padding: '20px',
    borderRadius: '10px',
    boxShadow: '0 2px 10px rgba(0,0,0,0.1)',
    textAlign: 'center'
  },
  inCartBadge: {
    position: 'absolute',
    top: '10px',
    right: '10px',
    background: '#0ea5e9',
    color: 'white',
    fontSize: '12px',
    fontWeight: '700',
    padding: '4px 8px',
    borderRadius: '999px'
  },
  editBox: {
    display: 'grid',
    gap: '8px',
    marginBottom: '8px'
  },
  editActions: {
    marginTop: '8px',
    display: 'flex',
    gap: '8px'
  },
  productName: {
    margin: '0 0 10px 0',
    color: '#333',
    fontSize: '18px'
  },
  productPrice: {
    margin: '0 0 5px 0',
    fontSize: '20px',
    fontWeight: 'bold',
    color: '#667eea'
  },
  productStock: {
    margin: '0 0 5px 0',
    color: '#666'
  },
  productCategory: {
    margin: '0 0 5px 0',
    color: '#666'
  },
  productVendor: {
    margin: '0 0 15px 0',
    color: '#666',
    fontSize: '14px'
  },
  addButton: {
    padding: '10px 15px',
    background: '#28a745',
    color: 'white',
    border: 'none',
    borderRadius: '5px',
    cursor: 'pointer',
    fontWeight: 'bold',
    width: '100%',
    ':disabled': {
      background: '#ccc',
      cursor: 'not-allowed'
    }
  }
};