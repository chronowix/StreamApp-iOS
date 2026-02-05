//
//  AuthViewModel.swift
//  StreamApp
//
//  Created by Cours on 05/02/2026.
//

import Foundation
internal import Combine

// AuthViewModel maj automatiquement l'écran si un élément change
class AuthViewModel: ObservableObject {
    //@Published permet de maj SwiftUI dès que la variable change
    @Published var isLoggedIn: Bool = false //true si un user est connecté
    @Published var currentUser: User? = nil //user connecté (nil = personne est connecté)
    @Published var errorMessage: String? = nil  //message d'erreur à afficher
    
    init() {
        checkCurrentuser()
    }
    
    func checkCurrentuser() {
        let user = PersistenceService.shared.loadCurrentUser()
        if user != nil {
            //un user s'est connecté
            currentUser = user
            isLoggedIn = true
        }
    }
    
    //création d'un nouveau compte
    func register(username: String, email: String, password: String) {
        //vérifie si les champs ne sont pas vides
        if username.isEmpty || email.isEmpty || password.isEmpty {
            errorMessage = "Veuillez remplir tous les champs"
            return
        }
        
        let newUser = PersistenceService.shared.createUser(username: username, email: email, password: password)

        if newUser != nil {
            currentUser = newUser
            isLoggedIn = true
            errorMessage = nil
        } else{
            errorMessage = "Un compte existe déjàavec ce mail!"
        }
    }
    
    
    //connexion
    func login(email: String, password: String) {
        if email.isEmpty || password.isEmpty {
            errorMessage = "Veuillez remplir tous les champs"
            return
        }
        
        let user = PersistenceService.shared.loginUser(email: email, password: password)

        if user != nil {
            currentUser = user
            isLoggedIn = true
            errorMessage = nil
        } else{
            errorMessage = "Email ou mot de passe incorrect!"
        }
    }
    
    func logout() {
        PersistenceService.shared.logout()
        currentUser = nil
        isLoggedIn = false
        errorMessage = nil
    }
 
}
