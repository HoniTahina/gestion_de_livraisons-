# Plateforme de gestion de livraisons multi-vendeurs

## Equipe

- Tahina HONI RIKA
- Houda Ouadah

## Contexte

Ce projet repond au sujet d'architecture n-tiers : creer une plateforme web de gestion de livraisons entre clients, vendeurs, livreurs et administrateurs.

## Ce qu'on a realise

On a developpe une application complete avec :
- un frontend web
- un backend API
- une base de donnees PostgreSQL

Le projet suit une architecture n-tiers avec separation claire entre presentation, logique metier et acces aux donnees.

## Fonctionnalites principales

- gestion des comptes (inscription, connexion, roles, profil)
- gestion des produits (ajout, modification, categories, stock)
- panier et commandes multi-vendeurs
- paiement simule avec statuts de commande
- detection du type de carte selon le numero saisi
- gestion des livraisons (attribution livreur + suivi)
- administration (utilisateurs, statistiques, codes d'invitation)

Precisions inscription :
- un client peut s'inscrire normalement
- vendeur et livreur s'inscrivent avec un code d'invitation envoye par l'administration

## Regles metier prises en compte

- split des commandes par vendeur
- gestion du stock en concurrence
- limite des livraisons actives par livreur
- commission plateforme

## Conception, tests et bonus

- diagrammes UML realises
- tests unitaires et d'integration
- bonus realises : WebSocket, SSE, Docker, CI/CD, cache simple

## Limites

- pas d'application mobile native dans ce depot
- paiement simule (pas de passerelle bancaire reelle)
