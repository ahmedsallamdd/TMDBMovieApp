//
//  TMDBMedia.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 05/08/2024.
//

import UIKit

//A unified media object of what we need in the app from movies and tv shows.
class TMDBMedia: Hashable {
    let id: Int
    var image: UIImage?
    let type: MediaType
    let title: String
    let genresAsString: String
    let overview: String
    let rating: Double
    let releaseDate: String
    let isAdult: Bool
    
    var posterUrl: String {
        didSet {
            loadPosterImage()
        }
    }
        
    init(id: Int, posterUrl: String, type: MediaType, title: String, genresAsString: String, overview: String, rating: Double, releaseDate: String, isAdult: Bool, image: UIImage? = nil) {
        self.id = id
        self.type = type
        self.title = title
        self.genresAsString = genresAsString
        self.overview = overview
        self.rating = rating
        self.releaseDate = releaseDate
        self.isAdult = isAdult
        self.posterUrl = posterUrl
        self.image = image
    }
    
    func loadPosterImage(completion: ((UIImage?) -> Void)? = nil) {
        if let image {
            DispatchQueue.main.async {
                completion?(image)
            }
            return
            
        } else {
            ImageDownloader.shared.download(link: posterUrl,
                                            completion: { image in
                completion?(image)
                self.image = image
            })
        }
    }
    
    static func from(movie: Movie) -> TMDBMedia {
        TMDBMedia(id: movie.id ?? 0,
                  posterUrl: movie.fullPosterLink,
                  type: .movie,
                  title: movie.title ?? "",
                  genresAsString: movie.genresAsString ?? "",
                  overview: movie.overview ?? "",
                  rating: movie.voteAverage ?? 0,
                  releaseDate: movie.releaseDate ?? "",
                  isAdult: movie.adult ?? false)
    }
    
    static func from(tvShow: TvShow) -> TMDBMedia {
        TMDBMedia(id: tvShow.id ?? 0,
                  posterUrl: tvShow.fullPosterLink,
                  type: .tvShow,
                  title: tvShow.name ?? "",
                  genresAsString: tvShow.genresAsString ?? "",
                  overview: tvShow.overview ?? "",
                  rating: tvShow.voteAverage ?? 0,
                  releaseDate: tvShow.firstAirDate ?? "",
                  isAdult: tvShow.adult ?? false)
    }
    
    static func == (lhs: TMDBMedia, rhs: TMDBMedia) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
