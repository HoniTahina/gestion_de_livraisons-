import { createContext, useContext, useEffect, useMemo, useReducer, useCallback } from 'react';

const CartContext = createContext();
const CART_STORAGE_KEY = 'cart_v2';

const normalizeId = (value) => String(value);

const normalizeItem = (item) => {
  const rawQuantity = Number(item?.quantity);
  const quantity = Number.isFinite(rawQuantity) && rawQuantity > 0 ? rawQuantity : 1;

  return {
    ...item,
    id: normalizeId(item.id),
    quantity,
    price: Number(item?.price ?? 0)
  };
};

const mergeCartItems = (items) => {
  const mergedMap = new Map();

  items.forEach((item) => {
    if (item?.id === undefined || item?.id === null) return;

    const normalized = normalizeItem(item);
    const existing = mergedMap.get(normalized.id);

    if (existing) {
      mergedMap.set(normalized.id, {
        ...existing,
        quantity: existing.quantity + normalized.quantity
      });
    } else {
      mergedMap.set(normalized.id, normalized);
    }
  });

  return Array.from(mergedMap.values());
};

const readInitialCart = () => {
  try {
    const rawV2 = localStorage.getItem(CART_STORAGE_KEY);
    if (rawV2) {
      const parsedV2 = JSON.parse(rawV2);
      return Array.isArray(parsedV2) ? mergeCartItems(parsedV2) : [];
    }

    // Migration legacy key once
    const legacyRaw = localStorage.getItem('cart');
    if (legacyRaw) {
      const legacyParsed = JSON.parse(legacyRaw);
      const migrated = Array.isArray(legacyParsed) ? mergeCartItems(legacyParsed) : [];
      localStorage.setItem(CART_STORAGE_KEY, JSON.stringify(migrated));
      localStorage.removeItem('cart');
      return migrated;
    }

    return [];
  } catch {
    return [];
  }
};

const cartReducer = (state, action) => {
  switch (action.type) {
    case 'ADD': {
      const product = action.payload;
      if (!product || product.id === undefined || product.id === null) return state;

      const normalizedProduct = normalizeItem({ ...product, quantity: 1 });
      const existing = state.find((item) => item.id === normalizedProduct.id);

      if (existing) {
        return state.map((item) =>
          item.id === normalizedProduct.id
            ? { ...item, quantity: item.quantity + 1 }
            : item
        );
      }

      return [...state, normalizedProduct];
    }
    case 'REMOVE': {
      const normalizedId = normalizeId(action.payload);
      return state.filter((item) => item.id !== normalizedId);
    }
    case 'INCREASE': {
      const normalizedId = normalizeId(action.payload);
      return state.map((item) =>
        item.id === normalizedId
          ? { ...item, quantity: item.quantity + 1 }
          : item
      );
    }
    case 'DECREASE': {
      const normalizedId = normalizeId(action.payload);
      return state
        .map((item) => {
          if (item.id !== normalizedId) return item;
          const nextQuantity = item.quantity - 1;
          if (nextQuantity <= 0) return null;
          return { ...item, quantity: nextQuantity };
        })
        .filter(Boolean);
    }
    case 'CLEAR':
      return [];
    default:
      return state;
  }
};

export function CartProvider({ children }) {
  const [cart, dispatch] = useReducer(cartReducer, [], readInitialCart);

  useEffect(() => {
    localStorage.setItem(CART_STORAGE_KEY, JSON.stringify(cart));
  }, [cart]);

  const addToCart = useCallback((product) => {
    dispatch({ type: 'ADD', payload: product });
  }, []);

  const removeFromCart = useCallback((id) => {
    dispatch({ type: 'REMOVE', payload: id });
  }, []);

  const increaseQuantity = useCallback((id) => {
    dispatch({ type: 'INCREASE', payload: id });
  }, []);

  const decreaseQuantity = useCallback((id) => {
    dispatch({ type: 'DECREASE', payload: id });
  }, []);

  const clearCart = useCallback(() => {
    dispatch({ type: 'CLEAR' });
  }, []);

  const total = useMemo(
    () =>
      cart.reduce((sum, item) => {
        const quantity = Number(item.quantity);
        const safeQuantity = Number.isFinite(quantity) && quantity > 0 ? quantity : 1;
        return sum + Number(item.price || 0) * safeQuantity;
      }, 0),
    [cart]
  );

  const cartItemsCount = useMemo(
    () =>
      cart.reduce((sum, item) => {
        const quantity = Number(item.quantity);
        const safeQuantity = Number.isFinite(quantity) && quantity > 0 ? quantity : 1;
        return sum + safeQuantity;
      }, 0),
    [cart]
  );

  const value = {
    cart,
    addToCart,
    removeFromCart,
    increaseQuantity,
    decreaseQuantity,
    clearCart,
    total,
    cartItemsCount
  };

  return (
    <CartContext.Provider value={value}>
      {children}
    </CartContext.Provider>
  );
}

export function useCart() {
  return useContext(CartContext);
}