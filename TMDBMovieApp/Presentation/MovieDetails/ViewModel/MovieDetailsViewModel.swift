//
//  MovieDetailsViewModel.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 04/08/2024.
//

import Foundation

class MovieDetailsViewModel: ViewModel {
    let media: TMDBMedia
    
    var favoritesIDs = CoreDataHelper.shared.fetchFavoritesIDsList()
    var isAddedToFavorites: Bool { favoritesIDs.map({ Int($0.id) }).contains(media.id) }
    
    init(media: TMDBMedia) {
        self.media = media
    }
    
    func addToFavorites() {
        CoreDataHelper.shared.addToFavorites(media: media)
        favoritesIDs = CoreDataHelper.shared.fetchFavoritesIDsList()
    }
    
    func deleteFromFavorites() {
        if let object = favoritesIDs.first(where: { Int($0.id) == media.id }) {
            CoreDataHelper.shared.deleteFromFavorites(object)
        }
    }
}
