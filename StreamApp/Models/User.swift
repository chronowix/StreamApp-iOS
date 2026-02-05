//
//  User.swift
//  StreamApp
//
//  Created by Cours on 04/02/2026.
//

import Foundation

struct User: Identifiable, Codable{
    let id: UUID
    var username: String
    var email: String
    var password: String
    var favoriteMovieIds: [Int]

    init(username: String, email: String, password: String) {
        self.id = UUID()
        self.username = username
        self.email = email
        self.password = password
        self.favoriteMovieIds = []
    }
}
