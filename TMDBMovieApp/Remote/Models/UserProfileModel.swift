//
//  UserProfileModel.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 04/08/2024.
//

import Foundation
import UIKit

struct UserProfileModel: Codable {
    let sub, name, givenName, familyName: String
    let picture: String
    let email: String
    let emailVerified: Bool

    var cachedImage: UIImage?
    var favorites: Set<SavedMediaEntity>?
    
    enum CodingKeys: String, CodingKey {
        case sub, name
        case givenName = "given_name"
        case familyName = "family_name"
        case picture, email
        case emailVerified = "email_verified"
    }
}
