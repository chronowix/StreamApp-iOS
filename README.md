# StreamApp

StreamApp est une application iOS développée en **SwiftUI** qui permet de :

* consulter les films populaires depuis l’API **TMDB**
* rechercher des films via l’API
* gérer une authentification locale (inscription / connexion)
* ajouter et supprimer des films en favoris

---

## Fonctionnalités

* 🔐 Authentification locale (UserDefaults)
* 🎞️ Liste des films populaires (TMDB)
* 🔍 Recherche de films via l’API TMDB
* ❤️ Gestion des favoris persistants
* 👤 Modification du profil utilisateur
* 🔄 Gestion des états (loading, erreurs)

---

## Technologies utilisées

* **Swift 5**
* **SwiftUI**
* **Combine**
* **Async / Await**
* **TMDB API**
* **UserDefaults** (persistance locale)

---

## Architecture

* `View` : interface utilisateur (SwiftUI)
* `ViewModel` : logique métier et états (`ObservableObject`)
* `Service` : appels API et persistance (`TMDBService`, `PersistenceService`)
* `Model` : structures de données (`Movie`, `User`)

Architecture inspirée du **MVVM**.

---

## Recherche de films

La recherche utilise l’API TMDB et est déclenchée lorsque l’utilisateur valide sa saisie dans la barre de recherche.

* Films populaires affichés par défaut
* Résultats de recherche affichés après appel API
* Retour automatique aux films populaires si la recherche est vidée

---

## Favoris

* Les favoris sont stockés sous forme d’IDs de films TMDB
* Les films favoris sont chargés via l’endpoint `/movie/{id}`
* Les favoris fonctionnent aussi bien depuis la liste populaire que depuis la recherche

---

## Lancer le projet

1. Cloner le projet
2. Ouvrir le fichier `.xcodeproj` ou `.xcworkspace`
3. Ajouter votre clé API TMDB dans `TMDBService`
4. Lancer l’application sur le simulateur iOS

---

## Mode développement

En mode `DEBUG`, l’utilisateur est automatiquement déconnecté au lancement afin de toujours démarrer sur l’écran de connexion.

---

## Améliorations possibles

* Sécurisation des mots de passe (Keychain + hash)
* Cache local des films
* Recherche avec debounce
* Tests unitaires
* Amélioration UI/UX (animations, empty states)

---

## Auteur

Projet réalisé dans le cadre d’un apprentissage SwiftUI et développement mobile iOS.


