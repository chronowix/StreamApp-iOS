//
//  ContentView.swift
//  StreamApp
//
//  Created by Cours on 04/02/2026.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        if authViewModel.isLoggedIn {
            // Si connecté, afficher l'app avec onglets
            TabView {
                // Onglet Films
                MovieListView()
                    .tabItem {
                        Label("Films", systemImage: "film")
                    }
                
                // Onglet Favoris (à créer)
                FavoritesView()
                    .tabItem {
                        Label("Favoris", systemImage: "heart.fill")
                    }
                
                ProfileView()
                    .tabItem{
                        Label("Profil", systemImage: "person.crop.circle")
                    }
            }
        } else {
            // Si non connecté
            NavigationStack {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
        .environmentObject(MovieViewModel())
}
