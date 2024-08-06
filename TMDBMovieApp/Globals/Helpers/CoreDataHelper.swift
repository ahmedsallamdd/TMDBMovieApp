//
//  CoreDataHelper.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 05/08/2024.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper {
    static let shared = CoreDataHelper()
    
    // MARK: - Core Data Stack
    private init() {}
    
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving Support
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func checkAndDeleteIfMediaExists(id: Int) -> Bool {
        let fetchRequest: NSFetchRequest<SavedMediaEntity> = SavedMediaEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let matchingRecords = try context.fetch(fetchRequest)
            
            if matchingRecords.count > 0 {

                //if it's only one record, then exit the func
                if matchingRecords.count == 1 { return true }
                
                //delete all duplicates except for only one
                let numberOfDuplicates = matchingRecords.count - 1
                
                for i in 0...numberOfDuplicates {
                    context.delete(matchingRecords[i])
                }
                
                saveContext()
                
                return true
            }
            
        } catch {
            print("Failed fetching by id: \(error)")
            return false
        }
        
        return false
    }
    
    func checkAndDeleteIfFavoriteExists(id: Int) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteMediaEntity> = FavoriteMediaEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let matchingRecords = try context.fetch(fetchRequest)
            
            if matchingRecords.count > 0 {

                //if it's only one record, then exit the func
                if matchingRecords.count == 1 { return true }
                
                //delete all except for only one
                let numberOfDuplicates = matchingRecords.count - 2
                
                guard numberOfDuplicates > 1 else {
                    return true
                }
                
                for i in 0...numberOfDuplicates {
                    context.delete(matchingRecords[i])
                }
                
                saveContext()
                
                return true
            }
            
        } catch {
            print("Failed fetching by id: \(error)")
            return false
        }
        
        return false
    }
    // MARK: - Save TMDBMedia
    func save(media: TMDBMedia) {
        if checkAndDeleteIfMediaExists(id: media.id) == false {
            let entity = SavedMediaEntity(context: context)
            entity.id = Int32(media.id)
            entity.posterUrl = media.posterUrl
            entity.image = media.image?.jpegData(compressionQuality: 1)
            entity.type = Int16(media.type.rawValue)
            entity.title = media.title
            entity.genresAsString = media.genresAsString
            entity.overview = media.overview
            entity.rating = media.rating
            entity.releaseDate = media.releaseDate
            entity.isAdult = media.isAdult
            
            saveContext()
        }
    }
    
    func save(mediaList: [TMDBMedia]) {
        for media in mediaList {
            save(media: media)
        }
    }
    
    func addToFavorites(media: TMDBMedia) {
        if checkAndDeleteIfFavoriteExists(id: media.id) == false {
            let entity = FavoriteMediaEntity(context: context)
            entity.id = Int32(media.id)
            
            saveContext()
        }
    }
    
    func deleteFromFavorites(_ item: FavoriteMediaEntity) {
        context.delete(item)
        saveContext()
    }
    
    func fetchFavoritesIDsList() -> [FavoriteMediaEntity] {
        let fetchRequest: NSFetchRequest<FavoriteMediaEntity> = FavoriteMediaEntity.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            return results.compactMap { entity in
                
                return entity
            }
        } catch {
            print("Failed fetching: \(error)")
            return []
        }
    }
    
    // MARK: - Fetch TMDBMedia
    func fetchMedia() -> [TMDBMedia] {
        let fetchRequest: NSFetchRequest<SavedMediaEntity> = SavedMediaEntity.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.map { entity in
                let id = Int(entity.id)
                let posterUrl = entity.posterUrl ?? ""
                let type = MediaType(rawValue: Int(entity.type)) ?? .movie
                let title = entity.title ?? ""
                let genresAsString = entity.genresAsString ?? ""
                let overview = entity.overview ?? ""
                let rating = entity.rating
                let releaseDate = entity.releaseDate ?? ""
                let isAdult = entity.isAdult
                
                var image: UIImage?
                if let imageData = entity.image { image = UIImage(data: imageData) }

                return TMDBMedia(id: id, posterUrl: posterUrl, type: type, title: title, genresAsString: genresAsString, overview: overview, rating: rating, releaseDate: releaseDate, isAdult: isAdult, image: image)
            }
        } catch {
            print("Failed fetching: \(error)")
            return []
        }
    }
    
    // MARK: - Fetch TMDBMedia by ID
    func fetchMedia(id: Int) -> TMDBMedia? {
        let fetchRequest: NSFetchRequest<SavedMediaEntity> = SavedMediaEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.fetchLimit = 1
        
        do {
            if let entity = try context.fetch(fetchRequest).first {
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
            }
        } catch {
            print("Failed fetching by id: \(error)")
        }
        
        return nil
    }
    
    func fetchMedia(id: Int) -> [TMDBMedia]? {
        let fetchRequest: NSFetchRequest<SavedMediaEntity> = SavedMediaEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            var mediaList: [TMDBMedia] = []
            for result in results {
                var image: UIImage?
                if let imageData = result.image { image = UIImage(data: imageData) }
                
                mediaList.append(TMDBMedia(
                    id: Int(result.id),
                    posterUrl: result.posterUrl ?? "",
                    type: MediaType(rawValue: Int(result.type)) ?? .movie,
                    title: result.title ?? "",
                    genresAsString: result.genresAsString ?? "",
                    overview: result.overview ?? "",
                    rating: result.rating,
                    releaseDate: result.releaseDate ?? "",
                    isAdult: result.isAdult,
                    image: image
                ))
            }
            
            return mediaList
            
        } catch {
            print("Failed fetching by id: \(error)")
        }
        
        return nil
    }
}
