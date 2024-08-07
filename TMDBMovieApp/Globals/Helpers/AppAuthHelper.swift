//
//  AppAuthHelper.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 01/08/2024.
//

import Foundation
import AppAuth
import UIKit

class AppAuthHelper {
    static let shared = AppAuthHelper()
    
    private let clientId = Bundle.main.object(forInfoDictionaryKey: "GoogleClientId") as? String
    private let redirectUri = URL(string: Bundle.main.object(forInfoDictionaryKey: "GoogleRedirectURL") as? String ?? "")
    private let issuer = URL(string: "https://accounts.google.com")!
    
    var authState: OIDAuthState?
    var userInfo: UserProfileModel?
    
    private init() {}
    
    func createAuthFlow(presentingVC: UIViewController, _ completion: @escaping (OIDAuthState?, String?) -> Void) {
        
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) { config, error in
            guard let config = config else {
                completion(nil, "Error retrieving discovery document: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let redirectUri = self.redirectUri, let clientId = self.clientId {
                let request = OIDAuthorizationRequest(
                    configuration: config,
                    clientId: clientId,
                    clientSecret: nil,
                    scopes: [OIDScopeOpenID, OIDScopeProfile, "email"],
                    redirectURL: redirectUri,
                    responseType: OIDResponseTypeCode,
                    additionalParameters: nil
                )
                
                // Present the authentication view controller.
                (UIApplication.shared.delegate as? AppDelegate)?.currentAuthorizationFlow = OIDAuthState.authState(
                    byPresenting: request,
                    presenting: presentingVC
                ) { authState, error in
                    if let authState = authState {
                        print("Got authorization tokens. Access token: \(authState.lastTokenResponse?.accessToken ?? "nil")")
                        self.authState = authState
                        completion(authState, nil)
                        // Handle successful authorization.
                    } else {
                        completion(nil, "Authorization error: \(error?.localizedDescription ?? "Unknown error")")
                    }
                }
            } else {
                completion(nil, "Invalid provider credentials.")
            }
        }
    }
}
