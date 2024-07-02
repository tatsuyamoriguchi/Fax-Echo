//
//  DateTimeFormatter.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 6/7/24.
//

import Foundation

class DateTimeFormatter {
    
    func formattedDate(from dateTimeString: String) -> String {
            // Create a DateFormatter for the input date/time string
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            // Convert the string to a Date object
            guard let date = inputFormatter.date(from: dateTimeString) else {
                return "Invalid date"
            }
            
            // Create a DateFormatter for the desired output format
            let outputFormatter = DateFormatter()
            outputFormatter.dateStyle = .full
            outputFormatter.timeStyle = .short
            
            // Set the time zone to the user's current time zone
            outputFormatter.timeZone = TimeZone.current
            
            // Use the current locale
            outputFormatter.locale = Locale.current
            
            // Format the date to the desired output format
            let formattedDate = outputFormatter.string(from: date)
            
            return formattedDate
        }
    
    
    func formattedDateOnly(from dateTimeString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let date = inputFormatter.date(from: dateTimeString) else {
            return "Invalid date"
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .full
        outputFormatter.timeStyle = .none
        outputFormatter.timeZone = TimeZone.current
        outputFormatter.locale = Locale.current
        
        return outputFormatter.string(from: date)
    }
    
    func formattedTime(from dateTimeString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let date = inputFormatter.date(from: dateTimeString) else {
            return "Invalid date"
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .none
        outputFormatter.timeStyle = .short
        outputFormatter.timeZone = TimeZone.current
        outputFormatter.locale = Locale.current
        
        return outputFormatter.string(from: date)
    }
    
    func date2String(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
