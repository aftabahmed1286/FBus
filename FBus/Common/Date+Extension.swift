//
//  Date+Extension.swift
//  FB
//
//  Created by Aftab Ahmed on 16/07/19.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit

extension Date {
    
    enum FBDateFormat {
        static let FBDateStringFormat = "d/MM/YY"
        static let FBTimeStringFormat = "H:mm"
    }

    func FBdateString(date: Date, timeZone: TimeZone) -> String {
        return self.dateTimeString(date: date, timeZone: timeZone, dateFormat: FBDateFormat.FBDateStringFormat)
    }
    
    func FBtimeString(date: Date, timeZone: TimeZone) -> String {
        return self.dateTimeString(date: date, timeZone: timeZone, dateFormat: FBDateFormat.FBTimeStringFormat)
    }
    
    func dateTimeString(date: Date, timeZone: TimeZone, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: date)
    }
    
    func dateFrom(timeStamp: Double) -> Date {
        let dateFromTimeStamp = Date(timeIntervalSince1970: timeStamp)
        return dateFromTimeStamp
    }
    
}
