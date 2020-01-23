//
//  String+Date.swift
//  Elite
//
//  Created by Manny Yusuf on 4/3/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

extension String {
    
    public func formatISODateString(dateFormat: String) -> String {
        var formatDate = self
        let isoDateFormatter = ISO8601DateFormatter()
        if let date = isoDateFormatter.date(from: self) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            formatDate = dateFormatter.string(from: date)
        }
        return formatDate
    }
    
    public func date() -> Date {
        var date = Date()
        let isoDateFormatter = ISO8601DateFormatter()
        if let isoDate = isoDateFormatter.date(from: self) {
            date = isoDate
        }
        return date
    }
    

    
    public func stringToDate(format: String) -> Date {
            let dateFormatter = DateFormatter()
        //"MMM d, yyyy hh:mm a"
            dateFormatter.dateFormat = format
            dateFormatter.locale = .current
            guard let date = dateFormatter.date(from: self) else {
                return Date()
    //            fatalError()
            }
            return date
        }
    
    
}
//
