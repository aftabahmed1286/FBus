//
//  StationTimetableModel.swift
//  FB
//
//  Created by Aftab Ahmed on 7/15/19.
//  Copyright © 2019 FAMCO. All rights reserved.
//

import Foundation
import SwiftUI

struct StationTimetableModel: Codable {
    
    var timetable: TimeTable?
    var station: RouteDetails?
    
    enum CodingKeys: String, CodingKey {
        case timetable, station
    }
    
    init() {
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.timetable = try container.decodeIfPresent(TimeTable.self, forKey: .timetable)
        self.station = try container.decodeIfPresent(RouteDetails.self, forKey: .station)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.timetable, forKey: .timetable)
        try container.encode(self.station, forKey: .station)
    }
}














