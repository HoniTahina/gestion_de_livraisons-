# Dossier UML et architecture n-tiers

Ce dossier regroupe les diagrammes utilises pour presenter le projet.

## 1. Diagramme de cas d'usage

Fichiers :
- `use-case-livraisons.mmd`
- `use-case-livraisons.svg`

Il montre les acteurs du systeme et leurs actions principales :
- client
- vendeur
- livreur
- administrateur

## 2. Diagramme de classes

Fichiers :
- `class-diagram-livraisons.mmd`
- `class-diagram-livraisons.svg`

Il presente les classes principales du projet :
- `User`
- `Product`
- `Order`
- `SubOrder`
- `OrderItem`
- `Delivery`

## 3. Diagramme d'architecture n-tiers

Fichiers :
- `architecture-n-tiers.mmd`
- `architecture-n-tiers.svg`

Il montre les trois couches du projet :
- presentation
- logique metier
- acces aux donnees

## Annexe : diagramme de sequence

Fichiers :
- `sequence-order-flow.mmd`
- `sequence-order-flow.svg`

Il resume le passage d'une commande de facon simple.

## Lien avec le projet

Les diagrammes correspondent a l'organisation du code :
- `frontend/` pour la presentation
- `backend/controllers` et `backend/services` pour la logique metier
- `backend/repositories` et `backend/models` pour les donnees

## Regles metier representees

- split des commandes par vendeur
- commission plateforme
- limite de livraisons par livreur
- protection du stock en concurrence
