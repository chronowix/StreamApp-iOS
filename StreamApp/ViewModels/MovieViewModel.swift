//
//  MovieViewModel.swift
//  StreamApp
//
//  Created by Cours on 05/02/2026.
//

import Foundation
internal import Combine

//viewmodel afin de gérer les films et les favoris
class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var favoritesMovies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    //Récupération des films populaires via l'api TMDB
    func fetchPopularMovies() {
        isLoading = true
        errorMessage = nil
        
        
        //utilisation de Task en tant que tâche asynchrone pour ne pas bloquer l'interface
        Task {
            do{
                //api call
                let fetchedMovies = try await TMDBService.shared.fetchPopularMovies()
                
                //maj sur le thread principal pour SwiftUI
                await MainActor.run {
                    self.movies = fetchedMovies
                    self.isLoading = false
                }
            } catch{
                //si erreur
                await MainActor.run {
                    self.errorMessage = "Impossible de charger les films. Veuillez réessayer plus tard."
                    self.isLoading = false
                }
            }
        }
    }
    
    
    func loadFavoritesMovies(for user: User){
        isLoading = true
        errorMessage = nil
        
        Task{
            do {
                let allMovies = try await TMDBService.shared.fetchPopularMovies()
                
                //filtrage des favoris
                let favoritesMovies = allMovies.filter { movie in
                    user.favoriteMovieIds.contains(movie.id)
                }
                
                await MainActor.run {
                    self.favoritesMovies = favoritesMovies
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Impossible de charger les films. Veuillez réessayer plus tard."
                    self.isLoading = false
                }
            }
        }
    }
    
    func addToFavorites(movie: Movie, userId: UUID) {
        PersistenceService.shared.addFavorite(userId: userId, movieId: movie.id)
        
        if !favoritesMovies.contains(where: { $0.id == movie.id }) {
            favoritesMovies.append(movie)
        }
    }
    
    
    func removeFromFavorites(movie: Movie, userId: UUID) {
        PersistenceService.shared.removeFavorite(userId: userId, movieId: movie.id)
        
        favoritesMovies.removeAll(where: { $0.id == movie.id })
    }
    
    
    func isFavorite(movie: Movie, userId: UUID) -> Bool {
        return PersistenceService.shared.isFavorite(userId: userId, movieId: movie.id)
    }
    
    
}
