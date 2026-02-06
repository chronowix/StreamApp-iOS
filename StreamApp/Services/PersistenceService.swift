//
//  PersistenceService.swift
//  StreamApp
//  Created by Alan on 04/02/2026
//

import Foundation

class PersistenceService {
    static let shared = PersistenceService()
    private init() {}

    private let usersKey = "users"
    private let currentUserKey = "currentUser"
    
    // permet de sauvegarder et charger les utilisateurs
    func saveUsers(users: [User]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(users) {
            UserDefaults.standard.set(encoded, forKey: usersKey)
        }
    }
    
    // charge les utilisateurs de l'appli
    func loadUsers() -> [User] {
        guard let data = UserDefaults.standard.data(forKey: usersKey) else {
            return []
        }

        let decoder = JSONDecoder()
        return (try? decoder.decode([User].self, from: data)) ?? []
    }

    
    // sauvegarde de l'utilisateur connecté
    func saveCurrentUser(user: User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: currentUserKey)
        }
    }
    
    // charger l'utilisateur connecté
    func loadCurrentUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: currentUserKey) else { return nil } // si personne n'est connecté
        let decoder = JSONDecoder()
        let user = try? decoder.decode(User.self, from: data)
        return user
    }
    
    // déconnexion
    func logout() {
        UserDefaults.standard.removeObject(forKey: currentUserKey)
    }
    
    // création de compte
    func createUser(username: String, email: String, password: String) -> User? {
        var users = loadUsers()

        // vérifier email unique
        if users.contains(where: { $0.email == email }) {
            return nil
        }

        let newUser = User(username: username, email: email, password: password)
        users.append(newUser)

        saveUsers(users: users)
        saveCurrentUser(user: newUser)

        return newUser
    }

    
    // connexion de l'utilisateur
    func loginUser(email: String, password: String) -> User? {
        let users = loadUsers()

        if let user = users.first(where: {
            $0.email == email && $0.password == password
        }) {
            saveCurrentUser(user: user)
            return user
        }

        return nil
    }

    
    // maj du compte via l'onglet profil
    func updateUser(_ updatedUser: User) {
        var users = loadUsers()

        guard let index = users.firstIndex(where: { $0.id == updatedUser.id }) else {
            return
        }

        users[index] = updatedUser
        saveUsers(users: users)
        saveCurrentUser(user: updatedUser)
    }

    func addFavorite(userId: UUID, movieId: Int) {
        var users = loadUsers()

        guard let index = users.firstIndex(where: { $0.id == userId }) else {
            return
        }

        if !users[index].favoriteMovieIds.contains(movieId) {
            users[index].favoriteMovieIds.append(movieId)
            saveUsers(users: users)

            if loadCurrentUser()?.id == userId {
                saveCurrentUser(user: users[index])
            }
        }
    }

    
    // suppression du favori de la liste de l'utilisateur connecté
    func removeFavorite(userId: UUID, movieId: Int){
        var users = loadUsers()
        
        for i in 0..<users.count{
            if users[i].id == userId {
                users[i].favoriteMovieIds.removeAll { $0 == movieId }
                saveUsers(users: users)
                
                //maj le user connecté
                if let currentUser = loadCurrentUser() {
                    if currentUser.id == userId {
                        saveCurrentUser(user: users[i])
                    }
                }
                break
            }
        }
    }
    
    
    func isFavorite(userId: UUID, movieId: Int) -> Bool {
        let users = loadUsers()
        
        //cherche le user
        for user in users {
            if user.id == userId {
                return user.favoriteMovieIds.contains(movieId)
            }
        }
        
        return false
    }
}
