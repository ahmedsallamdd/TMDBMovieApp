//
//  BiometricsAuthenticator.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 06/08/2024.
//

import Foundation
import LocalAuthentication

class BiometricsAuthenticator {
    class func authenticate(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            let errorMessage = error?.localizedDescription ?? "Your device can't authenticate your login with biometrics."
            
            print("BiometricsLogin: \(errorMessage)")
            completion(.failure(.genericError(description: errorMessage)))
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthentication,
                               localizedReason: "We need to aunthenticate your login.",
                               reply: { isSuccess, error in
            
            guard isSuccess, error == nil else {
                let errorMessage = error?.localizedDescription ?? "Authentication failed!"
                print("BiometricsLogin: \(errorMessage)")
                
                completion(.failure(.genericError(description: errorMessage)))
                
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(Void()))
            }
        })
    }
}
