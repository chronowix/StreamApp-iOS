//
//  StreamAppApp.swift
//  StreamApp
//
//  Created by Cours on 04/02/2026.
//
import SwiftUI

@main
struct StreamAppApp: App {
    
    //ViewModels partagés dans l'appli
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var movieViewModel = MovieViewModel()
        
    var body: some Scene {
        WindowGroup {
            //Point d'entrée
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(movieViewModel)
        }
    }
}
