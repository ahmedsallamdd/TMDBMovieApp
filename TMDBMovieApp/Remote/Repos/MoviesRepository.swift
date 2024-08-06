//
//  MoviesRepository.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 05/08/2024.
//

import Foundation

class MoviesRepository: MediaRepository {
    var genres: [Genre] = []
    var currentPageNumber: Int = 0
    var totalNumberOfPages: Int = 0
    
    func fetchData(_ completion: @escaping (Result<[TMDBMedia], NetworkError>) -> Void) {
        
        if isConnectedToInternet == true {
            if genres.count > 0 {
                self.fetchMoviesNextPage(genres: self.genres, completion)
                
            } else {
                self.fetchMovieGenres({ [weak self] result in
                    switch result {
                    case .success:
                        if let self {
                            self.fetchMoviesNextPage(genres: self.genres, completion)
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                })
            }
            
        } else {
            completion(.success(CoreDataHelper.shared.fetchMedia().filter({ $0.type == .movie })))
        }
    }
    
    fileprivate func fetchMovieGenres(_ completion: @escaping (Result<Void, NetworkError>) -> Void) {
        MovieService().fetchMovieGenres() { [weak self] result in
            switch result {
            case .success(let genres):
                self?.genres = genres
                completion(.success(Void()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    fileprivate func fetchMoviesNextPage(genres: [Genre],
                                         _ completion: @escaping (Result<[TMDBMedia], NetworkError>) -> Void) {
        
        currentPageNumber = currentPageNumber + 1
        MovieService().fetchMovies(pageNumber: currentPageNumber, { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    
                    let tmdbMovies = model.results?.map({ movie in
                        let genresAsString = movie.getGenresAsString(using: genres)
                        var modifiedMovie = movie
                        modifiedMovie.genresAsString = genresAsString
            
                        let media = TMDBMedia.from(movie: modifiedMovie)
                        return media
                    })
                    
                    self?.totalNumberOfPages = model.totalPages ?? 0
                    
                    if let media = tmdbMovies, media.count > 0 {
                        ImageDownloader.shared.download(links: media.map({$0.posterUrl}), completion: { images in
                            for item in media {
                                let image = images[item.posterUrl]
                                if let image { item.image = image }
                            }
                            
                            CoreDataHelper.shared.save(mediaList: media)
                            completion(.success(media))
                        })
                    } else {
                        completion(.success([]))
                    }
                    
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        })
    }
}
