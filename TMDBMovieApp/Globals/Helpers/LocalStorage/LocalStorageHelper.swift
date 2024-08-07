//
//  LocalStorageHelper.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 02/08/2024.
//

import Foundation

protocol Storable {
    func save(for key: LocalStorageKey, value: Any)
    func get(for key: LocalStorageKey) -> Any?
}

class LocalStorageHelper: Storable {
    static let shared = LocalStorageHelper()
    
    private let keychain = KeychainHelper.shared
    private let userDefaults = UserDefaultsHelper.shared
    
    private init() {}
    
    func save(for key: LocalStorageKey, value: Any) {
        key.securityLevel == .high ? keychain.save(for: key, value: value) : userDefaults.save(for: key, value: value)
    }
    
    func get(for key: LocalStorageKey) -> Any? {
        key.securityLevel == .high ? keychain.get(for: key) : userDefaults.get(for: key)
    }    
}

public enum LocalStorageKey: String {
    case accessToken
    case accessTokenExpirationDate
    case email
    
    var securityLevel: SequrityLevel {
        switch self {
        case .accessToken:
            return .high
        case .accessTokenExpirationDate, .email:
            return .normal
        }
    }
}

enum SequrityLevel {
    case high //saved in keychain
    case normal // saved in user defaults
}
