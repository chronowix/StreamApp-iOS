//
//  FavoritesView.swift
//  StreamApp
//
//  Created by Cours on 05/02/2026.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var movieViewModel: MovieViewModel
    
    var body: some View {
        NavigationStack {
            if let user = authViewModel.currentUser{
                if movieViewModel.isLoading{
                    ProgressView("Chargement des favoris")
                } else if movieViewModel.favoriteMovies.isEmpty{
                    VStack(spacing: 16){
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Aucun film favori")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Ajoutez des à vos favoris depuis l'onglet Films ;)")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                } else {
                    //liste des favs
                    List(movieViewModel.favoriteMovies){ movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)){
                            MovieRowView(movie: movie)
                        }
                    }
                    .navigationTitle("Mes favoris")
                    .refreshable { //pull to refresh
                        movieViewModel.loadFavoriteMovies(for: user)
                    }
                }
            } else {
                Text("Vous devez être connecté pour accéder à cette partie")
            }
        }
        .onAppear {
            //chargement des favs au démarrage
            if let user = authViewModel.currentUser{
                movieViewModel.loadFavoriteMovies(for: user)
            }
        }
        //refresh des favoris
        .onChange(of: authViewModel.currentUser?.favoriteMovieIds.count){
            if let user = authViewModel.currentUser{
                movieViewModel.loadFavoriteMovies(for: user)
            }
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(AuthViewModel())
        .environmentObject(MovieViewModel())
}


