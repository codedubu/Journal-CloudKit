//
//  DateToString.swift
//  CloudKitJournal
//
//  Created by River McCaine on 2/1/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import Foundation

extension Date {
    enum DateFormatType: String {
           case full = "EEEE, MMM d, yyyy"
           case fullNumeric = "MM/dd/yyyy"
           case fullNumericTimestamp = "MM-dd-yyyy HH:mm"
           case monthDayTimestamp = "MMM d, h:mm a"
           case monthYear = "MMMM yyyy"
           case monthDayYear = "MMM d, yyyy"
           case fullWithTimezone = "E, d MMM yyyy HH:mm:ss Z"
           case fullNumericWithTimezone = "yyyy-MM-dd'T'HH:mm:ssZ"
           case short = "dd.MM.yy"
           case timestamp = "HH:mm:ss.SSS"
        }
    
    func dateToSTring() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a, yyyy"
        return formatter.string(from: self)
    }
    
}
