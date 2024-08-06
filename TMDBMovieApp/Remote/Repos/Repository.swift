//
//  Repository.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 06/08/2024.
//

import Foundation
import SystemConfiguration

//Middle layer between View-ViewModel layer (presentation part) and Data layer (Network or Cache parts).
protocol Repository {
    associatedtype T

    var isConnectedToInternet: Bool { get }
    func fetchData(_ completion: @escaping (Result<T, NetworkError>) -> Void)
}

protocol MediaRepository: Repository {
    associatedtype T = [TMDBMedia]
}

protocol AuthUserRepository: Repository {
    associatedtype T = UserProfileModel
}

extension Repository {
    var isConnectedToInternet: Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
}
