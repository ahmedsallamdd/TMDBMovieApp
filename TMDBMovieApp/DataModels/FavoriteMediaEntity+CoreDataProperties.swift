//
//  Favorite+CoreDataProperties.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 05/08/2024.
//

import Foundation
import CoreData

extension FavoriteMediaEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMediaEntity> {
        return NSFetchRequest<FavoriteMediaEntity>(entityName: "Favorite")
    }

    @NSManaged public var id: Int32

    // Add computed properties or other custom methods if needed
}
