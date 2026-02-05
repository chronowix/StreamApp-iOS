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
    
    var body: some View {
        NavigationStack{
            if movieViewModel.isLoading {
                //indicateur de chargement
                ProgressView("Chargement des films...")
            } else if let errorMessage = movieViewModel.errorMessage {
                //affichage erreur
                VStack {
                    Text(errorMessage)
                        .foregroundColor(.red)
                    Button("Réessayer") {
                        movieViewModel.fetchPopularMovies()
                    }
                }
            } else{
                //afficher liste films
                List(movieViewModel.movies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        MovieRowView(movie: movie)
                    }
                }
                .navigationTitle(Text("Films populaires"))
            }
        }
        .onAppear{
            if movieViewModel.movies.isEmpty {
                movieViewModel.fetchPopularMovies()
            }
        }
    }
}

//vue pour afficher un film
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
#Preview{
    MovieListView()
        .environmentObject(MovieViewModel())
        .environmentObject(AuthViewModel())
}

