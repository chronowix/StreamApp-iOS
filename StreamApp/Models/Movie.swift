//
//  Movie.swift
//  StreamApp
//
//  Created by Cours on 04/02/2026.
//

import Foundation

struct Movie: Identifiable, Codable {
    let id: Int 
    let title: String
    let overview: String
    let posterPath: String?
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }

    //url des posters
    var posterURL: URL?{
        guard let posterPath = posterPath else {return nil}
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
}