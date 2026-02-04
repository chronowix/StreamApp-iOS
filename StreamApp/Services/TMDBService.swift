//
//  TMDBService.swift
//  StreamApp
//
//  Created by Cours on 04/02/2026.
//

import Foundation


class TMDBService {
    static let shared = TMDBService()
    private init() {}
    
    func fetchPopularMovies() async throws -> [Movie] {
        let urlString = "\(Constants.tmdbBaseURL)/movie/popular?api_key=\(Constants.tmdbAPIKey)&language=fr-FR"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(TMDBResponse.self, from: data)
        return response.results
    }
    
    func searchMovies(query: String) async throws -> [Movie] {
        let urlString = "\(Constants.tmdbBaseURL)/search/movie?api_key=\(Constants.tmdbAPIKey)&language=fr-FR&query=\(query)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(TMDBResponse.self, from: data)
        return response.results
    }
}

// Structure pour décoder la réponse TMDB
struct TMDBResponse: Codable {
    let results: [Movie]
}