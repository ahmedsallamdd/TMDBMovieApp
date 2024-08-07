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
    
    func checkAndDeleteIfUserExists(email: String) -> Bool {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
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
    func saveCurrentUser(_ user: UserProfileModel) {
        if checkAndDeleteIfUserExists(email: user.email) == false {
            let entity = UserEntity(context: context)
            entity.email = user.email
            entity.firstName = user.givenName
            entity.lastName = user.familyName
            entity.picture = user.cachedImage?.pngData()
            entity.favorites = user.favorites as? NSSet
            
            saveContext()
            print("new user with email=\(user.email) saved to core data")
        }
        
        print("A user with email=\(user.email) already exists in core data")
    }
    
    func fetchCurrentUser(userEmail: String) -> UserProfileModel? {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", userEmail)
        
        do {
            if let entity = try context.fetch(fetchRequest).first(where: {$0.email == userEmail}) {
                var image: UIImage?
                if let imageData = entity.picture { image = UIImage(data: imageData) }
                
                let user = UserProfileModel(sub: "",
                                            name: "",
                                            givenName: entity.firstName ?? "",
                                            familyName: entity.lastName ?? "",
                                            picture: "",
                                            email: entity.email ?? "",
                                            emailVerified: .random(),
                                            cachedImage: image,
                                            favorites: entity.favorites as? Set<SavedMediaEntity>)
                print("User with email=\(userEmail) fetched successfully. favCount=\(entity.favorites?.count ?? 0)")
                saveContext()
                return user
            }
        } catch {
            print("Failed fetching by id: \(error)")
        }
        
        return nil
    }
    
    func addMediaToUserFavorites(email: String, media: TMDBMedia) {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            if let user = try context.fetch(fetchRequest).first(where: {$0.email == email}) {
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
                
                user.addToFavorites(entity)
                
                saveContext()
                print("Media added to user's favorites successfully.")
            } else {
                print("User not found.")
            }
        } catch {
            print("Failed to add media to user's favorites: \(error)")
        }
    }

    func removeMediaFromUserFavorites(email: String, media: TMDBMedia) {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            if let user = try context.fetch(fetchRequest).first {
                if let favoriteMovies = user.favorites as? Set<SavedMediaEntity> {
                    if let movieToRemove = favoriteMovies.first(where: { $0.id == media.id }) {
                        context.delete(movieToRemove)
                        
                        saveContext()
                        print("Media removed from user's favorites successfully.")
                    } else {
                        print("Media not found in user's favorites.")
                    }
                }
            } else {
                print("User not found.")
            }
        } catch {
            print("Failed to remove media from user's favorites: \(error)")
        }
    }

}
