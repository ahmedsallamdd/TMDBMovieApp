//
//  TvShowsEndPoints.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 02/08/2024.
//

import Foundation

enum TvShowsEndPoints: Requestable {
    case tvShows(page: Int)
    case genres
    case tvShowFullDetails(id: Int)
    
    var baseURL: String {
        switch self {
        case .tvShows, .genres, .tvShowFullDetails:
            "https://api.themoviedb.org/3"
        }
    }
    
    var endpointURL: String {
        switch self {
        case .tvShows:
            "/discover/tv"
        case .genres:
            "/genre/tv/list"
        case .tvShowFullDetails(let id):
            "/tv/\(id)"
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
        case .tvShows(let page):
            [
                "api_key": "f760c441b75eeb6b0536d5483a25102f",
                "page": page
            ]
            
        case .genres, .tvShowFullDetails:
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
