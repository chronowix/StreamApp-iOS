//
//  MovieDetailView.swift
//  StreamApp
//
//  Created by Cours on 05/02/2026.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var movieViewModel: MovieViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let posterURL = movie.posterURL {
                    AsyncImage(url: posterURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray)
                            .aspectRatio(2/3, contentMode: .fit)
                    }
                    .frame(maxHeight: 400)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(movie.title).font(.title).bold()
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", movie.voteAverage)).font(.headline)
                    }
                    
                    if let user = authViewModel.currentUser {
                        Button(action: {
                            if movieViewModel.isFavorite(movie: movie, userId: user.id){
                                movieViewModel.removeFromFavorites(movie: movie, userId: user.id)
                            } else{
                                movieViewModel.addToFavorites(movie: movie, userId: user.id)
                            }
                            
                            //rechargement user
                            authViewModel.refreshCurrentUser()
                            
                            //rechargement favs
                            movieViewModel.loadFavoriteMovies(for: user)
                            
                        }) {
                                HStack {
                                    Image(systemName: movieViewModel.isFavorite(movie: movie, userId: user.id) ? "heart.fill" : "heart")
                                    Text(movieViewModel.isFavorite(movie: movie, userId: user.id) ? "Retirer des favoris" : "Ajouter aux favoris")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(movieViewModel.isFavorite(movie: movie, userId: user.id) ? Color.red : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                    
                    Text("Synopsis")
                        .font(.headline)
                        .padding(.top)
                    
                    Text(movie.overview)
                        .font(.body)
                }
                .padding()
            }
        }
        .navigationTitle("Détail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack{
        MovieDetailView(movie: Movie(
            id: 1,
            title: "Test",
            overview: "testetstetstest",
            posterPath: nil,
            voteAverage: 8.5
        ))
        .environmentObject(AuthViewModel())
        .environmentObject(MovieViewModel())
    }
}
