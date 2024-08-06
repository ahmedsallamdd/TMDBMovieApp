//
//  GeneralResponseModel.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 03/08/2024.
//

import Foundation

// MARK: - GeneralResponseModel
struct GeneralPagedResponseModel<T: Codable>: Codable {
    let page, totalResults, totalPages: Int?
    let results: T?

    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}
