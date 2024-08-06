//
//  MovieEndPoints.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 03/08/2024.
//

import Foundation

enum MovieEndPoints: Requestable {
    case movies(page: Int)
    case genres
    case movieFullDetails(id: Int)
    
    var baseURL: String {
        switch self {
        case .movies, .genres, .movieFullDetails:
            "https://api.themoviedb.org/3"
        }
    }
    
    var endpointURL: String {
        switch self {
        case .movies:
            "/discover/movie"
        case .genres:
            "/genre/movie/list"
        case .movieFullDetails(let id):
            "/movie/\(id)"
        }
    }
    
    var method: HTTPMethodType {
        .get
    }
    
    var headerParameters: [String : String] {
        [:]
    }
    
    var queryParameters: [String : Any] {
        switch self {
        case .movies(let page):
            [
                "api_key": "f760c441b75eeb6b0536d5483a25102f",
                "page": page
            ]
            
        case .genres, .movieFullDetails:
            [
                "api_key": "f760c441b75eeb6b0536d5483a25102f"
            ]
        }
    }
    
    var bodyParameters: [String : Any] {
        [:]
    }
    
    var isPrintable: Bool {
        true
    }
    
    
}
