//
//  JourneyDetails.swift
//  FB
//
//  Created by Aftab Ahmed on 7/17/19.
//  Copyright © 2019 FAMCO. All rights reserved.
//

import Foundation

struct JourneyDetails: Codable {
    
    var through_the_stations: String?
    var datetime: DateTime?
    var line_direction: String?
    var route: [RouteDetails]?
    var ride_id: Double?
    var trip_uid: String?
    var line_code: String?
    var direction: String?
    
    enum CodingKeys: String, CodingKey {
        case through_the_stations, datetime, line_direction, route, ride_id, trip_uid, line_code, direction
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.through_the_stations = try container.decodeIfPresent(String.self, forKey: .through_the_stations)
        self.datetime = try container.decodeIfPresent(DateTime.self, forKey: .datetime)
        self.line_direction = try container.decodeIfPresent(String.self, forKey: .line_direction)
        self.route = try container.decodeIfPresent([RouteDetails].self, forKey: .route)
        self.ride_id = try container.decodeIfPresent(Double.self, forKey: .ride_id)
        self.trip_uid = try container.decodeIfPresent(String.self, forKey: .trip_uid)
        self.line_code = try container.decodeIfPresent(String.self, forKey: .line_code)
        self.direction = try container.decodeIfPresent(String.self, forKey: .direction)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.through_the_stations, forKey: .through_the_stations)
        try container.encode(self.datetime, forKey: .datetime)
        try container.encode(self.line_direction, forKey: .line_direction)
        try container.encode(self.route, forKey: .route)
        try container.encode(self.ride_id, forKey: .ride_id)
        try container.encode(self.trip_uid, forKey: .trip_uid)
        try container.encode(self.line_code, forKey: .line_code)
        try container.encode(self.direction, forKey: .direction)
    }
    
}
