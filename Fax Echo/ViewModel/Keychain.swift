//
//  Keychain.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 5/13/24.
//

import Foundation
import Security

struct UserCredentials: Codable {
    let email: String
    let password: String
    let appid: String
    let apikey: String
    let userid: String
    let faxNumber: String
}


struct Keychain {
    
    static let shared = Keychain()
    static let service = "FaxEcho"
    
    // Function to check if a user account already exists in Keychain
    // change to check if entered email address exists in Keychain in Registration()
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
    
    // Usage:
    // let userCredentials = UserCredentials(email: "user1@example.com", password: "password123", appid: "appid1", apikey: "apikey1", userid: "userid1", faxNumber: "faxNumber1")
    // try saveUserCredentials(userCredentials)
    static func saveUserCredentials(_ credentials: UserCredentials) throws {
        // Encode the credentials to Data
        let encoder = JSONEncoder()
        guard let credentialsData = try? encoder.encode(credentials) else {
            throw KeychainError.encodingError
        }

        // Keychain query for storing user credentials
        let credentialsQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: credentials.email,
            kSecValueData as String: credentialsData
        ]

        // Add credentials to Keychain
        let status = SecItemAdd(credentialsQuery as CFDictionary, nil)
        if status != errSecSuccess {
            throw KeychainError.unhandledError(status: status)
        }
    }

    // Usage:
    // let retrievedCredentials = try retrieveUserCredentials(email: "user1@example.com")
    // print(retrievedCredentials)
    static func retrieveUserCredentials(email: String) throws -> UserCredentials {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: email,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }

        guard let credentialsData = item as? Data else {
            throw KeychainError.dataConversionError
        }

        let decoder = JSONDecoder()
        guard let credentials = try? decoder.decode(UserCredentials.self, from: credentialsData) else {
            throw KeychainError.decodingError
        }

        return credentials
    }

    
    // Replace with func saveUserCredentials
    static func save(email:String, password: String, appid: String, apikey: String, userid: String, faxNumber: String) throws {
        
        // need to change this with email and password?
        guard let passwordData = password.data(using: .utf8),
              let appidData = appid.data(using: .utf8),
              let apikeyData = apikey.data(using: .utf8),
              let useridData = userid.data(using: .utf8),
              let faxNumberData = faxNumber.data(using: .utf8) else {
            throw KeychainError.dataConversionError
        }
        
        // Keychain query for password
        let passwordQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: "\(service)_password",
                kSecAttrAccount as String: email,
                kSecValueData as String: passwordData
            ]
        
        // Keychain query for appid
            let appidQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: "\(service)_appid",
                kSecAttrAccount as String: email,
                kSecValueData as String: appidData
            ]
        
         let apikeyQuery: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: email,
            kSecValueData as String: apikeyData
        ]
        
        let useridQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "\(service)_userid",
            kSecAttrAccount as String: email,
            kSecValueData as String: useridData
        ]
        
        let faxNumberQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "\(service)_faxNumber",
            kSecAttrAccount as String: email,
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
    
    // Replace with retrieveUserCredentials
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
    
    // Replace with retrieveUserCredentials
    func retrieveMyFaxNumber(appid: String) throws -> String? {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
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
    case encodingError
    case decodingError
}
