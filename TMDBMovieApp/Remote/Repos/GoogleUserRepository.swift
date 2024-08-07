//
//  GoogleUserRepository.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 06/08/2024.
//

import Foundation

class GoogleUserRepository: AuthUserRepository {
    func fetchData(_ completion: @escaping (Result<UserProfileModel?, NetworkError>) -> Void) {
        if isConnectedToInternet {
            
            NetworkService.shared.requestData(request: UserEndPoints.userInfo,
                                              expectedModelType: UserProfileModel.self,
                                              completion: { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(var model):
                        LocalStorageHelper.shared.save(for: .email, value: model.email)
                        ImageDownloader.shared.download(link: model.picture, completion: { image in
                            model.cachedImage = image
                            AppAuthHelper.shared.userInfo = model
                            CoreDataHelper.shared.saveCurrentUser(model)
                            completion(.success(model))
                        })
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            })
            
        } else {
            DispatchQueue.main.async {
                if let lastSignedInUserEmail = LocalStorageHelper.shared.get(for: .email) as? String {
                    completion(.success(CoreDataHelper.shared.fetchCurrentUser(userEmail: lastSignedInUserEmail)))
                }
            }
        }
    }
}
