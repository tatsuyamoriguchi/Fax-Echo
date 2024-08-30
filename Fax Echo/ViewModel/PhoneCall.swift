//
//  PhoneCall.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 8/30/24.
//

import Foundation
import Contacts

class PhoneCall {
    
    // Obtain originating_fax_tsid from Fax data
    func getFaxNumber(fax: Fax) -> String {
        return fax.originating_fax_tsid
    }
    
    // Access iOS Contacts app
    func fetchSpecificContact(fax: Fax) async -> [CNContact] {
        // Run in the background
        
        // Get access to the contacts store
        let store = CNContactStore()
        
        // Keys to fetch
        let keys = [CNContactOrganizationNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey]
                
        // Predicate to find contacts with a matching phone number
        let predicate = CNContact.predicateForContacts(matching: CNPhoneNumber(stringValue: fax.originating_fax_tsid))
        
        do {
            // Fetch the contacts matching the predicate
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keys as [CNKeyDescriptor])
            
            // Extract phone numbers from the matching contacts
//            var matchedContacts: [String] = []
//            for contact in contacts {
//                for phoneNumber in contact.phoneNumbers {
//                    matchedContacts.append(phoneNumber.value.stringValue)
//                }
//            }
            
            // Extract contact names, organization names, phone types, and phone numbers into an array, results
//            [
//                ["John Doe", "ABC Company", "Work", "123-123-1234"]
//                ["John Doe", "ABC Company", "Home", "123-654-3456"]
//                ["Jane Doe", "ABC Company", "Work", "123-123-3456"]
//                ["Jane Doe", "ABC Company", "Mobile", "123-123-3456"]
//            ]
            
            return contacts
            
        } catch {
            print("Failed to fetch contacts: \(error)")
            return []
        }
    }
    
}
