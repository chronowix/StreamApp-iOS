//
//  StreamAppApp.swift
//  StreamApp
//
//  Created by Cours on 04/02/2026.
//
import SwiftUI

@main
struct StreamAppApp: App {
    
    // Créer les ViewModels qui seront partagés dans toute l'app
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var movieViewModel = MovieViewModel() 
    
    var body: some Scene {
        WindowGroup {
            // Point d'entrée de l'app
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(movieViewModel)
        }
    }
}
