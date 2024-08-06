//
//  TvShowsRepository.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 06/08/2024.
//

import Foundation

class TvShowsRepository: MediaRepository {
    var genres: [Genre] = []
    var currentPageNumber: Int = 0
    var totalNumberOfPages: Int = 0
    
    func fetchData(_ completion: @escaping (Result<[TMDBMedia], NetworkError>) -> Void) {
        
        if isConnectedToInternet == true {
            if genres.count > 0 {
                self.fetchTvShowNextPage(genres: self.genres, completion)
                
            } else {
                self.fetchTvShowGenres({ [weak self] result in
                    switch result {
                    case .success:
                        if let self {
                            self.fetchTvShowNextPage(genres: self.genres, completion)
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
    
    fileprivate func fetchTvShowGenres(_ completion: @escaping (Result<Void, NetworkError>) -> Void) {
        TvShowService().fetchTvShowGenres() { [weak self] result in
            switch result {
            case .success(let genres):
                self?.genres = genres
                completion(.success(Void()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    fileprivate func fetchTvShowNextPage(genres: [Genre],
                                         _ completion: @escaping (Result<[TMDBMedia], NetworkError>) -> Void) {
        self.currentPageNumber += 1
        TvShowService().fetchTvShows(pageNumber: self.currentPageNumber, { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    
                    let tmdbTvShows = model.results?.map({ tvShow in
                        let genresAsString = tvShow.getGenresAsString(using: genres)
                        var modifiedTvShow = tvShow
                        modifiedTvShow.genresAsString = genresAsString
                        return TMDBMedia.from(tvShow: modifiedTvShow)
                    })
                    
                    self?.totalNumberOfPages = model.totalPages ?? 0
                    
                    if let media = tmdbTvShows, media.count > 0 {
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
