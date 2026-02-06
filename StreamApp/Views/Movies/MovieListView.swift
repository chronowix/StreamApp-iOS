//
//  MovielistView.swift
//  StreamApp
//
//  Created by Cours on 05/02/2026.
//

import SwiftUI

struct MovieListView: View {
    @EnvironmentObject var movieViewModel: MovieViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            if movieViewModel.isLoading {
                // Indicateur de chargement
                ProgressView("Chargement des films...")
                
            } else if let errorMessage = movieViewModel.errorMessage {
                // Affichage erreur
                VStack {
                    Text(errorMessage)
                        .foregroundColor(.red)
                    Button("Réessayer") {
                        movieViewModel.fetchPopularMovies()
                    }
                }
                
            } else {
                // Liste des films (ici films populaires selon TMDB)
                List(moviesToDisplay) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        MovieRowView(movie: movie)
                    }
                }
                .navigationTitle("Films populaires")
                .searchable(text: $searchText, prompt: "Rechercher un film") // barre de recherche
                .onSubmit(of: .search){
                    movieViewModel.searchMovies(query: searchText)
                }
                .onChange(of: searchText) { _, newValue in
                    if newValue.isEmpty {
                        movieViewModel.searchResults = []
                    }
                }
            }
        }
        .onAppear {
            if movieViewModel.movies.isEmpty {
                movieViewModel.fetchPopularMovies()
            }
        }
    }
    
    // affiche les films à afficher lors de la recherche
    private var moviesToDisplay: [Movie] {
        if !searchText.isEmpty {
            return movieViewModel.searchResults
        } else {
            return movieViewModel.movies
            }
        }
    }

// vue d'affichage d'un film
struct MovieRowView: View {

    let movie: Movie

    var body: some View {
        HStack {

            // Image du film
            if let posterURL = movie.posterURL {
                AsyncImage(url: posterURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(width: 60, height: 90)
                .cornerRadius(8)
                .clipped()
            }

            // Infos film
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)

                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)

                    Text(String(format: "%.1f", movie.voteAverage))
                        .font(.caption)
                }
            }
        }
    }
}

#Preview {
    MovieListView()
        .environmentObject(MovieViewModel())
        .environmentObject(AuthViewModel())
}
