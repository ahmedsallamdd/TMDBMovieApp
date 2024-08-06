//
//  HomeViewModel.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 03/08/2024.
//

import Foundation

class HomeViewModel<MovieRepo: MediaRepository, TVShowRepo: MediaRepository, UserRepo: AuthUserRepository>: ViewModel where MovieRepo.T: Sequence, TVShowRepo.T: Sequence, MovieRepo.T.Element == TMDBMedia, TVShowRepo.T.Element == TMDBMedia {
    
    var moviesRepository: MovieRepo
    var tvShowsRepository: TVShowRepo
    var userRepository: UserRepo
    
    var movies: [TMDBMedia] = []
    var tvShows: [TMDBMedia] = []
    
    var didLoadMoreMovies: () -> Void = {}
    var didLoadMoreTvShows: () -> Void = {}
    var didLoadUserProfileInfo: () -> Void = {}
    
    init(moviesRepository: MovieRepo, tvShowsRepository: TVShowRepo, userRepository: UserRepo) {
        self.moviesRepository = moviesRepository
        self.tvShowsRepository = tvShowsRepository
        self.userRepository = userRepository
    }
    
    func fetchData() {
        movies.removeAll()
        tvShows.removeAll()
        
        fetchUserInfo()
        
        fetchNextPage(.movie) { [weak self] in
            self?.didLoadMoreMovies()
        }
        
        fetchNextPage(.tvShow) { [weak self] in
            self?.didLoadMoreTvShows()
        }
    }
    
    func fetchNextPage(_ type: MediaType, completion: @escaping () -> Void ) {
        self.startLoading()
        switch type {
        case .movie:
            moviesRepository.fetchData({ [weak self] result in
                self?.finishLoading()
                DispatchQueue.main.async {
                    switch result {
                    case .success(let movies):
                        self?.movies.append(contentsOf: movies)
                        completion()
                        
                    case .failure(let error):
                        self?.errorMessage = error.descriptionString
                    }
                }
            })
            
        case .tvShow:
            tvShowsRepository.fetchData({ [weak self] result in
                self?.finishLoading()
                DispatchQueue.main.async {
                    switch result {
                    case .success(let tvShows):
                        self?.tvShows.append(contentsOf: tvShows)
                        completion()
                        
                    case .failure(let error):
                        self?.errorMessage = error.descriptionString
                    }
                }
            })
        }
    }
    
    fileprivate func fetchUserInfo() {
        self.startLoading()
        userRepository.fetchData({ [weak self] result in
            self?.finishLoading()
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.didLoadUserProfileInfo()
                    
                case .failure(let error):
                    self?.errorMessage = error.descriptionString
                }
            }
        })
    }
}
