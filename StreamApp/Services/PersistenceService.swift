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
    
    func loadUsers() -> [User]? {
        guard let data = UserDefaults.standard.data(forKey: usersKey) else { return [] }
        let decoder = JSONDecoder()
        let users = try? decoder.decode([User].self, from: data)
        return users ?? []
    }
    
    //sauvegarde de l'utilisateur connecté
    func saveCurrentUser(user: User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: currentUserKey)
        }
    }
    
    //charger l'utilisateur connecté
    func loadCurrentUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: currentUserKey) else { return nil } // si perssonne n'est connecté
        let decoder = JSONDecoder()
        let user = try? decoder.decode(User.self, from: data)
        return user
    }
    
    //déconnexion
    func logout() {
        UserDefaults.standard.removeObject(forKey: currentUserKey)
    }
    
    //création de compte
    func createUser(username: String, email: String, password: String) -> User? {
        var users = loadUsers()
        
        //vérification si le mail existe dans la liste des users
        for user in users ?? [] {
            if user.email == email {
                return nil 
            }
        }
        
        let newUser = User(username: username, email: email, password: password)
        users?.append(newUser)
        saveUsers(users: users ?? [])
        saveCurrentUser(user: newUser)
        return newUser
        
    }
    
    //connexion de l'utilisateur
    func loginUser(email: String, password: String) -> User? {
        let users = loadUsers()
        
        for user in users ?? [] {
            if user.email == email && user.password == password { // email et mdp correspond
                saveCurrentUser(user: user)
                return user
            } else {
                return nil
            }
        }
        return nil
    }
    
    //maj du compte
    func updateUser(_ updatedUser: User){
        var users = loadUsers()
        
        //trouver l'utilisateur dans la liste
        for i in 0..<users!.count {
            if users![i].email == updatedUser.email {
                users![i] = updatedUser
                saveUsers(users: users!)
                
                
                //maj aussi si l'utilisateur est connecté
                if let currentUser = loadCurrentUser() {
                    if currentUser.id == updatedUser.id {
                        saveCurrentUser(user: updatedUser)
                    }
                }
                break
            }
        }
    }
    
    func addFavorite(userId: UUID, movieId: Int){
        var users = loadUsers()
        
        for i in 0..<users!.count{
            if users![i].id == userId {
                //ajouter le film s'il n'est pas dans les favoris
                if !users![i].favoriteMovieIds.contains(movieId) {
                    users![i].favoriteMovieIds.append(movieId)
                    saveUsers(users: users!)
                    
                    //maj le user connecté
                    if let currentUser = loadCurrentUser() {
                        if currentUser.id == userId {
                            saveCurrentUser(user: users![i])
                        }
                    }
                }
                break
            }
        }
    }
    
    
    func removeFavorite(userId: UUID, movieId: Int){
        var users = loadUsers()
        
        for i in 0..<users!.count{
            if users![i].id == userId {
                users![i].favoriteMovieIds.removeAll { $0 == movieId }
                saveUsers(users: users!)
                
                //maj le user connecté
                if let currentUser = loadCurrentUser() {
                    if currentUser.id == userId {
                        saveCurrentUser(user: users![i])
                    }
                }
                break
            }
        }
    }
    
    
    func isFavorite(userId: UUID, movieId: Int) -> Bool {
        var users = loadUsers()
        
        //cherche le user
        for user in users ?? [] {
            if user.id == userId {
                return user.favoriteMovieIds.contains(movieId)
            }
        }
        
        return false
    }
}
