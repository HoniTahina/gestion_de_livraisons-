# Projet de gestion de livraisons

## Equipe
Tahina HONI RIKA 
Houda Ouada

## Présentation
Ce projet est une plateforme de gestion de livraisons multi-vendeurs développée en architecture n-tiers. Il permet aux clients, vendeurs, livreurs et administrateurs d'interagir via une application web.


## Objectifs
- Fournir une interface frontend React pour les utilisateurs
- Créer une API backend en Node.js/Express
- Utiliser PostgreSQL pour le stockage des données
- Gérer les rôles et l'authentification
- Supporter les commandes multi-vendeurs, la gestion de stock et le suivi des livraisons
- Intégrer un système de codes d'invitation pour les vendeurs et livreurs
- Ajouter des diagrammes UML, des tests et un déploiement Docker

## Architecture générale
Le projet suit une architecture n-tiers avec separation claire entre presentation, logique metier et acces aux donnees:
- `frontend/` : client React + Vite
- `backend/` : API Node.js/Express avec logique métier et accès aux données
- `db` : base PostgreSQL gérée par Docker Compose

## Schémas et diagrammes
Les diagrammes UML sont disponibles dans `docs/uml` :
- `architecture-n-tiers.mmd`
- `class-diagram-livraisons.mmd`
- `sequence-order-flow.mmd`
- `use-case-livraisons.mmd`
- `dossier-uml-rendu.md`

## Technologies utilisées
- Node.js 20
- Express 5
- PostgreSQL 16
- Sequelize
- React 18
- Vite
- Docker / Docker Compose
- Jest / Supertest
- WebSocket / SSE pour notifications en temps réel

## Structure du backend
- `backend/app.js` : point d'entrée et initialisation du serveur
- `backend/config/db.js` : configuration Sequelize
- `backend/models/` : modèles Sequelize
- `backend/controllers/` : logique de contrôle des routes
- `backend/services/` : services métiers
- `backend/repositories/` : abstraction des accès DB
- `backend/routes/` : routes API
- `backend/utils/` : outils utilitaires
- `backend/scripts/` : scripts de backup et restauration

## Structure du frontend
- `frontend/src/App.jsx` : composant principal
- `frontend/src/pages/` : pages de l'application
- `frontend/src/services/api.js` : client Axios configuré
- `frontend/src/context/` : gestion globale du contexte utilisateur et panier
- `frontend/src/components/` : composants réutilisables

## Fonctionnalités principales
- Inscription et connexion
- Gestion des profils utilisateurs par rôle
- Catalogue produit et gestion de stock
- Panier et commande multi-vendeurs
- Gestion des statuts de commande et paiement simulé
- Attribution et suivi des livraisons
- Administration des utilisateurs et codes d'invitation
- Gestion des codes invite vendeur/livreur
- Statistiques et tableaux de bord admin

## Utilisateurs de test créés automatiquement
Au démarrage du backend, les comptes suivants sont générés si absents :
- Admin : `admin@platform.com` / `Password123!`
- Livreur : `driver1@platform.com` / `Password123!`
- Vendeur 1 : `seller1@platform.com` / `Password123!`
- Vendeur 2 : `seller2@platform.com` / `Password123!`
- Client : `client1@platform.com` / `Password123!`

## Connexion administrateur
Pour accéder à l'interface admin et gérer les utilisateurs/codes :
- Email : `admin@platform.com`
- Mot de passe : `Password123!`

Precisions inscription :
- un client peut s'inscrire normalement
- vendeur et livreur s'inscrivent avec un code d'invitation envoye par l'administration

## Installation et démarrage
### Avec Docker
1. Lancer Docker Desktop
2. Depuis la racine du projet :
   ```bash
   docker-compose up --build
   ```
3. Accéder à :
   - Frontend : `http://localhost:3000`
   - Backend : `http://localhost:5000`

### Sans Docker
#### Backend
```bash
cd backend
npm install
npm run dev
```
#### Frontend
```bash
cd frontend
npm install
npm run dev
```

## Variables d'environnement
Si en local la base de donnees ne repond pas, verifier que PostgreSQL est demarre et que les variables du `.env` s
ont correctes.
Backend : `backend/.env`
- `DB_HOST`
- `DB_NAME`
- `DB_USER`
- `DB_PASS`
- `JWT_SECRET`
- `PORT`
- `AUTO_DB_BACKUP`
- `DB_ALTER`

Frontend : `frontend/package.json` expose `VITE_API_URL`

## Tests
### Backend
- Tests unitaires : `npm run test:unit`
- Tests d'intégration : `npm run test:integration`

## Points importants
- Le backend attend la base PostgreSQL avant de démarrer
- Les codes d'invitation sont nécessaires pour créer des comptes vendeurs et livreurs
- Les données sont stockées dans PostgreSQL via Docker volume `pgdata`

## Notes de développement
- La config de la base est dans `backend/config/db.js`
- Les relations Sequelize sont définies dans `backend/models/index.js`
- Les routes d'authentification sont dans `backend/routes/authRoutes.js`

## Comment utiliser le projet
1. Démarrer les services
2. Se connecter avec l'admin
3. Gérer les codes d'invitation
4. Créer des produits et passer des commandes
5. Voir les livraisons et les statistiques

## Remarques
Ce projet est un prototype fonctionnel qui simule une plateforme de livraison multi-vendeurs. Le paiement est simulé, et la mise en production nécessiterait une sécurisation supplémentaire, un vrai service de paiement et un stockage des secrets approprié.
