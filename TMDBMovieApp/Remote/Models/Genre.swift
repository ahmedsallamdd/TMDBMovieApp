//
//  Genre.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 03/08/2024.
//

import Foundation

// MARK: - GetUniversitiesModel
struct GenreModel: Codable {
    let genres: [Genre]
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
}
