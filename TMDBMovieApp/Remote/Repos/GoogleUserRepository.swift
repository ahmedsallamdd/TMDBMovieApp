//
//  GoogleUserRepository.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 06/08/2024.
//

import Foundation

class GoogleUserRepository: AuthUserRepository {
    func fetchData(_ completion: @escaping (Result<UserProfileModel, NetworkError>) -> Void) {
        if isConnectedToInternet {
            NetworkService.shared.requestData(request: UserEndPoints.userInfo,
                                              expectedModelType: UserProfileModel.self,
                                              completion: { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        AppAuthHelper.shared.userInfo = model
                        //TODO: Save it to core data
                        completion(.success(model))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            })
        } else {
            DispatchQueue.main.async {
                //TODO: create a core data model
            }
        }
    }
}
