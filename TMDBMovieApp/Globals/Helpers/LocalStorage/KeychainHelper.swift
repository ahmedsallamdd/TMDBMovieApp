//
//  KeychainHelper.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 02/08/2024.
//

import Foundation
import Security

class KeychainHelper: Storable {
    
    static let shared = KeychainHelper()
    private init() {}
    
    func save(for key: LocalStorageKey, value: Any) {
        let data: Data
        if let value = value as? String {
            data = value.data(using: .utf8)!
        } else {
            // Serialize any other type of data if needed
            data = try! NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary) // Delete any existing item
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            print("Error saving data to Keychain: \(status)")
        }
    }
    
    func get(for key: LocalStorageKey) -> Any? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: kCFBooleanTrue as Any,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess else {
            print("Error fetching data from Keychain: \(status)")
            return nil
        }
        
        guard let data = item as? Data else { return nil }
        
        if let string = String(data: data, encoding: .utf8) {
            return string
        } else {
            // Deserialize any other type of data if needed
            return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
        }
    }
    
    func delete(for key: LocalStorageKey) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess {
            print("Error deleting data from Keychain: \(status)")
        }
    }
}
