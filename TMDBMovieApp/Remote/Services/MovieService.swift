//
//  MovieService.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 03/08/2024.
//

import Foundation

class MovieService {
    func fetchMovies(pageNumber: Int,
                     _ completion: @escaping (Result<GeneralPagedResponseModel<[Movie]>, NetworkError>) -> Void) {
        
        NetworkService.shared.requestData(request: MovieEndPoints.movies(page: pageNumber),
                                          expectedModelType: GeneralPagedResponseModel<[Movie]>.self,
                                          completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    completion(.success(model))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        })
    }
    
    func fetchMovieGenres(_ completion: @escaping (Result<[Genre], NetworkError>) -> Void) {
        NetworkService.shared.requestData(request: MovieEndPoints.genres,
                                          expectedModelType: GenreModel.self,
                                          completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    completion(.success(model.genres))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        })
    }
}
