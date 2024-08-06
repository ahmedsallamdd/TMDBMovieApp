//
//  UserDefaultsHelper.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 02/08/2024.
//

import Foundation

class UserDefaultsHelper: Storable {
    static let shared = UserDefaultsHelper()
    
    fileprivate var userDefaults = UserDefaults()
    
    private init() {}
    
    func save(for key: LocalStorageKey, value: Any) {
        userDefaults.setValue(value, forKey: key.rawValue)
    }
    
    func get(for key: LocalStorageKey) -> Any? {
        userDefaults.object(forKey: key.rawValue)
    }
    
}
