//
//  UserEntity+CoreDataProperties.swift
//  
//
//  Created by Ahmed Sallam on 06/08/2024.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var picture: Data?
    @NSManaged public var favorites: NSSet?

}

// MARK: Generated accessors for favorites
extension UserEntity {

    @objc(addFavoritesObject:)
    @NSManaged public func addToFavorites(_ value: SavedMediaEntity)

    @objc(removeFavoritesObject:)
    @NSManaged public func removeFromFavorites(_ value: SavedMediaEntity)

    @objc(addFavorites:)
    @NSManaged public func addToFavorites(_ values: NSSet)

    @objc(removeFavorites:)
    @NSManaged public func removeFromFavorites(_ values: NSSet)

}
