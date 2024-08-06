//
//  FavoritesViewModel.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 06/08/2024.
//

import Foundation

class FavoritesViewModel: ViewModel {
    var favorites: [TMDBMedia] = []
    
    func fetchData() {
        favorites.removeAll()
        
        let favIDs = CoreDataHelper.shared.fetchFavoritesIDsList()
        for object in favIDs {
            self.favorites.append(contentsOf: CoreDataHelper.shared.fetchMedia(id: Int(object.id)) ?? [])
        }
    }
}
