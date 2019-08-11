//
//  DateTime.swift
//  FB
//
//  Created by Aftab Ahmed on 7/17/19.
//  Copyright © 2019 FAMCO. All rights reserved.
//

import Foundation

struct DateTime: Codable {
    
    var timestamp: Double?
    var tz: String?
    
    enum CodingKeys: String, CodingKey {
        case timestamp, tz
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.timestamp = try container.decodeIfPresent(Double.self, forKey: .timestamp)
        self.tz = try container.decodeIfPresent(String.self, forKey: .tz)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.timestamp, forKey: .timestamp)
        try container.encode(self.tz, forKey: .tz)
    }
    
    //        let dateTimeValueStrings = self.dateString()
    //        self.dateValString = dateTimeValueStrings.date
    //        self.dateTimeString = dateTimeValueStrings.time
    
    func dateString() -> (date: String, time: String){
        guard let timeStamp = timestamp, let timeZone = tz else {
            return ("", "")
        }
        let dateFromTimeStamp = Date().dateFrom(timeStamp: timeStamp)
        let tZone =  TimeZone(abbreviation: timeZone)!
        return
            (
                Date().FBdateString(date: dateFromTimeStamp, timeZone: tZone),
                Date().FBtimeString(date: dateFromTimeStamp, timeZone: tZone)
        )
    }
}
