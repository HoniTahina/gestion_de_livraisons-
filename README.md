# Plateforme de gestion de livraisons multi-vendeurs

Projet conforme au cas pratique d'architecture n-tiers.

## 1) Architecture n-tiers

- Presentation: `frontend/` (React + Vite)
- Logique metier: `backend/controllers`, `backend/services`
- Acces donnees: `backend/repositories`, `backend/models` (Sequelize)

## 2) API REST

- `POST /auth/register`, `POST /auth/login`
- `GET/POST/PUT /products`
- `POST/GET/PUT /orders`
- `POST/GET/PUT /deliveries`
- `GET/PUT /users/me`
- `GET /admin/stats`

## 3) Regles metier implementees

- Split automatique des commandes par vendeur (`SubOrder`)
- Verrouillage transactionnel des produits pour proteger le stock en concurrence
- Limite de 3 livraisons actives par livreur
- Commission plateforme (5%)

## 4) Temps reel

- SSE: `GET /events`
- WebSocket: `ws://localhost:5000/ws`

## 5) Tests

Dans `backend/`:

- `npm run test:unit`
- `npm run test:integration`
- `npm test`

## 6) Lancement local

### Backend

1. Creer `backend/.env` avec:
   - `DB_NAME=delivery_db`
   - `DB_USER=postgres`
   - `DB_PASS=postgres`
   - `JWT_SECRET=...`
2. `cd backend`
3. `npm install`
4. `npm run dev`

### Frontend

1. Creer `frontend/.env` avec:
   - `VITE_API_URL=http://localhost:5000`
   - `VITE_PAYPAL_URL=https://www.paypal.com`
2. `cd frontend`
3. `npm install`
4. `npm run dev`

## 7) Docker

- `docker compose up --build`

## 8) CI/CD

- Workflow GitHub Actions: `.github/workflows/ci.yml`
- Build frontend + tests backend automatiques sur push et pull request.
