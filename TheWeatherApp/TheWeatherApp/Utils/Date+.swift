//
//  Date+.swift
//  TheWeatherApp
//
//  Created by Kevin Lagat on 1/18/21.
//

import Foundation

struct DateISO: Codable {
    var date: Date
}

extension Date {

    static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale.current
        
        return dateFormatter
    }
    
    static func formatDate(date: Date, format: String = "h:mm a") -> String {
        return Date.dateFormatter.string(from: date)
    }
    
}
