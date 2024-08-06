//
//  NetworkErrors.swift
//  GenericNetworkLayer
//
//  Created by Ahmed Sallam on 31/07/2024.
//

import Foundation

public enum NetworkError: Error {
    case invalidResponseData // 1
    case invalidURL // 2
    case parsingError // 3
    case noNetworkAvailable // 4
    case unauthorized // 5
    case nonSpecificError // 6
    case invalidRequestData // 8

    case genericError(description: String?) // 10
    
    var descriptionString: String {
        switch self {
        case .unauthorized:
            return "Your login session has expired."
        case .invalidResponseData:
            return "Invalid response data"
        case .invalidURL:
            return "Couldn't construct URL properly. Please contact our support."
        case .parsingError:
            return "Couldn't parse response JSON"
        case .noNetworkAvailable:
            return "No internet connection found. Please resolve your connection issue and try again"
        case .nonSpecificError:
            return "Something went wrong.\nPlease contact our support if the issue presists."
        case .invalidRequestData:
            return "Data collected for this request is invalid. Please contact our support."
            
        case .genericError(let description):
            return description ?? NetworkError.nonSpecificError.descriptionString
            
        }
    }
}
