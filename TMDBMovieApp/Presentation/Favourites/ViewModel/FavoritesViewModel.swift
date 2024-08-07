//
//  FavoritesViewModel.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 06/08/2024.
//

import Foundation
import UIKit

class FavoritesViewModel: ViewModel {
    var favorites: [TMDBMedia] = []
    
    func fetchData() {
        favorites.removeAll()
        if let currentUserEmail = LocalStorageHelper.shared.get(for: .email) as? String,
            let user = CoreDataHelper.shared.fetchCurrentUser(userEmail: currentUserEmail),
           let userFavorites = user.favorites {
            
            self.favorites =  userFavorites.map({ entity in
                var image: UIImage?
                if let imageData = entity.image { image = UIImage(data: imageData) }
                
                return TMDBMedia(
                    id: Int(entity.id),
                    posterUrl: entity.posterUrl ?? "",
                    type: MediaType(rawValue: Int(entity.type)) ?? .movie,
                    title: entity.title ?? "",
                    genresAsString: entity.genresAsString ?? "",
                    overview: entity.overview ?? "",
                    rating: entity.rating,
                    releaseDate: entity.releaseDate ?? "",
                    isAdult: entity.isAdult,
                    image: image
                )                
            })
        }
    }
}
