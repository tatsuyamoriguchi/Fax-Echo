//
//  Keychain.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 5/13/24.
//

import Foundation
import Security

struct Keychain {
    
    static let shared = Keychain()
    static let service = "FaxEcho"
    
    // Function to check if a user account already exists in Keychain
    static func doesAnyUserExist() -> Bool {
        // Define query parameters
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true
        ]
        
        // Try to fetch existing item from Keychain
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        print("doesAnyUserExist SecItemCopyMatching status: \(status)")
        
        // Check if user account exists or not
        if status == errSecSuccess {
            return true
        } else if status == errSecItemNotFound {
            return false
        } else {
            print("Keychain error: \(status)")
            return false
        }
    }
    
    
    static func save(appid: String, apikey: String, userid: String, faxNumber: String) throws {
        guard let apikeyData = apikey.data(using: .utf8),
        let useridData = userid.data(using: .utf8),
        let faxNumberData = faxNumber.data(using: .utf8) else {
            throw KeychainError.dataConversionError
        }
        
        let apikeyQuery: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: appid,
            kSecValueData as String: apikeyData
        ]
        
        let useridQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "\(service)_userid",
            kSecAttrAccount as String: appid,
            kSecValueData as String: useridData
        ]
        
        let faxNumberQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "\(service)_faxNumber",
            kSecAttrAccount as String: appid,
            kSecValueData as String: faxNumberData
        ]

        let apikeyStatus = SecItemAdd(apikeyQuery as CFDictionary, nil)
        if apikeyStatus != errSecSuccess {
            throw KeychainError.unhandledError(status: apikeyStatus)
        }
        
        let useridStatus = SecItemAdd(useridQuery as CFDictionary, nil)
        if useridStatus != errSecSuccess {
            throw KeychainError.unhandledError(status: useridStatus)
        }
        
        let faxNumberStatus = SecItemAdd(faxNumberQuery as CFDictionary, nil)
        if faxNumberStatus != errSecSuccess {
            throw KeychainError.unhandledError(status: faxNumberStatus)
        }
        
    }
    
    func retrieveApikey(appid: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Keychain.service,
            kSecAttrAccount as String: appid,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue!
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                print("appid given: \(appid)")                
                print("No apikey found for the given appid")
                return nil
            } else {
                throw KeychainError.unhandledError(status: status)
            }
        }
        
        guard let apikeyData = result as? Data else {
            throw KeychainError.unexpectedDataError
        }
        
        guard let apikey = String(data: apikeyData, encoding: .utf8) else {
            throw KeychainError.dataConversionError
        }
        
        return apikey
    }

    func retrieveMyFaxNumber(appid: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrService as String: Keychain.service,
            kSecAttrService as String: "\(Keychain.service)_faxNumber",
            kSecAttrAccount as String: appid,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue!
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                print("No fax number found for the given appid")
                print("appid: \(appid)")
                print("fax number: \(Keychain.service)_faxNumber")
                return nil
            } else {
                print("Unhandled Keychain error: \(status)")
                throw KeychainError.unhandledError(status: status)
            }
        }
        
        guard let faxNumberData = result as? Data else {
            print("Unexpected data error")
            throw KeychainError.unexpectedDataError
        }
        
        guard let faxNumber = String(data: faxNumberData, encoding: .utf8) else {
            print("Data conversion error")
            throw KeychainError.dataConversionError
        }
        
        return faxNumber
    }
}

enum KeychainError: Error {
    case dataConversionError
    case unhandledError(status: OSStatus)
    case unexpectedDataError
}

