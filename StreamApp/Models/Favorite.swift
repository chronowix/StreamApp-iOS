//
//  Favorite.swift
//  StreamApp
//Created by Alan on 04/02/2026
//

import Foundation

struct Favorite: Identifiable, Codable{
    let id: UUID
    let userId: UUID
    let movieId: Int
    let addedAt: Date
    
    init(userId: UUID, movieId: Int) {
        self.id = UUID()
        self.userId = userId
        self.movieId = movieId
        self.addedAt = Date()
    }
}

