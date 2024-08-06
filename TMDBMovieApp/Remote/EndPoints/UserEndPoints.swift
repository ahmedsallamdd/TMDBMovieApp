//
//  UserEndPoints.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 04/08/2024.
//

import Foundation

enum UserEndPoints: Requestable {
    case userInfo
    
    var baseURL: String {
        "https://openidconnect.googleapis.com"
    }
    
    var endpointURL: String {
        switch self {
        case .userInfo:
            "/v1/userinfo"
        }
    }
    
    var method: HTTPMethodType {
        .get
    }
    
    var headerParameters: [String : String] {
        ["Authorization" : "Bearer \(LocalStorageHelper.shared.get(for: .accessToken) as? String ?? "")"]
    }
    
    var queryParameters: [String : Any] {
        [:]
    }
    
    var bodyParameters: [String : Any] {
        [:]
    }
    
    var isPrintable: Bool {
        true
    }
    
    
}
