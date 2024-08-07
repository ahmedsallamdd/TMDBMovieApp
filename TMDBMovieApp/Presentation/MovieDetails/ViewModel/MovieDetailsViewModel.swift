//
//  MovieDetailsViewModel.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 04/08/2024.
//

import Foundation

class MovieDetailsViewModel: ViewModel {
    fileprivate let lastSignedInUserEmail = LocalStorageHelper.shared.get(for: .email) as? String
    
    let media: TMDBMedia

    var isAddedToFavorites: Bool {
        if let user = getRefreshedCurrentUserInfo(),
           let userFavorites = user.favorites, userFavorites.count > 0 {
            for favorite in userFavorites {
                if favorite.id == media.id { return true }
            }            
        }
        
        return false
    }
    
    init(media: TMDBMedia) {
        self.media = media
    }
    
    fileprivate func getRefreshedCurrentUserInfo() -> UserProfileModel? {
        if let currentUserEmail = LocalStorageHelper.shared.get(for: .email) as? String {
            return CoreDataHelper.shared.fetchCurrentUser(userEmail: currentUserEmail)
        }
        
        return nil
    }
    
    func addToFavorites() {
        if let lastSignedInUserEmail {
            CoreDataHelper.shared.addMediaToUserFavorites(email: lastSignedInUserEmail, media: media)
        }
    }
    
    func deleteFromFavorites() {
        if let lastSignedInUserEmail {
            CoreDataHelper.shared.removeMediaFromUserFavorites(email: lastSignedInUserEmail, media: media)
        }
    }
}
