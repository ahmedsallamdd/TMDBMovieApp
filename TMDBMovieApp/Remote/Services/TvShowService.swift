//
//  TvShowService.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 05/08/2024.
//

import Foundation

class TvShowService {
    func fetchTvShows(pageNumber: Int,
                      _ completion: @escaping (Result<GeneralPagedResponseModel<[TvShow]>, NetworkError>) -> Void) {
        
        NetworkService.shared.requestData(request: TvShowsEndPoints.tvShows(page: pageNumber),
                                          expectedModelType: GeneralPagedResponseModel<[TvShow]>.self,
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
    
    func fetchTvShowGenres(_ completion: @escaping (Result<[Genre], NetworkError>) -> Void) {
        NetworkService.shared.requestData(request: TvShowsEndPoints.genres,
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
