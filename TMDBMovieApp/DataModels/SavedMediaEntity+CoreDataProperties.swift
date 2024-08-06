//
//  SavedMediaEntity+CoreDataProperties.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 05/08/2024.
//

import Foundation
import CoreData

extension SavedMediaEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedMediaEntity> {
        return NSFetchRequest<SavedMediaEntity>(entityName: "TMDBMediaEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var posterUrl: String?
    @NSManaged public var image: Data?
    @NSManaged public var type: Int16
    @NSManaged public var title: String?
    @NSManaged public var genresAsString: String?
    @NSManaged public var overview: String?
    @NSManaged public var rating: Double
    @NSManaged public var releaseDate: String?
    @NSManaged public var isAdult: Bool

    // Add computed properties or other custom methods if needed
}
