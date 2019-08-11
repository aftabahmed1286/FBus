//
//  TimeTable.swift
//  FB
//
//  Created by Aftab Ahmed on 7/17/19.
//  Copyright © 2019 FAMCO. All rights reserved.
//

import Foundation

struct TimeTable: Codable {
    
    var arrivalsDatesSorted: [String]?
    var departuresDatesSorted: [String]?
    
    var arrivalsGrouped: [String: [JourneyDetails]]? {
        didSet {
            self.arrivalsDatesSorted = self.datesSortedForJourney(type: .ARR)
        }
    }
    var departuresGrouped: [String: [JourneyDetails]]? {
        didSet {
            self.departuresDatesSorted = self.datesSortedForJourney(type: .DEP)
        }
    }
    
    var arrivals: [JourneyDetails]?
    {
        didSet {
            self.arrivalsGrouped = self.journeysGrouped(type: .ARR)
        }
    }
    
    var departures: [JourneyDetails]?
    {
        didSet {
            self.departuresGrouped = self.journeysGrouped(type: .DEP)
        }
    }
    
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case arrivals, departures, message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        defer {
            do {
                self.arrivals = try container.decodeIfPresent([JourneyDetails].self, forKey: .arrivals)
                self.departures = try container.decodeIfPresent([JourneyDetails].self, forKey: .departures) }
            catch {
                print("Parsing Error")
            }
        }
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.arrivals, forKey: .arrivals)
        try container.encode(self.departures, forKey: .departures)
        try container.encode(self.message, forKey: .message)
    }
    
    enum JourneyType {
        case ARR, DEP
    }
    
    private func journeysGrouped(type: JourneyType) -> [String: [JourneyDetails]]? {
        var retVal: [String: [JourneyDetails]]?
        
        guard let journeys = (type == .ARR) ? arrivals : departures else {
            return nil
        }
        
        //Group by Date
        retVal = journeys.reduce(into: [:]) { dict, journeyDetail in
            if let dateStr = journeyDetail.datetime?.dateString().date {
                dict![dateStr, default: [journeyDetail]] += [journeyDetail]
            }
        }
        return retVal
    }
    
    private func datesSortedForJourney(type: JourneyType) -> [String] {
        guard let journeysGroupedByDate = type == .ARR ? self.arrivalsGrouped : self.departuresGrouped else {
            return []
        }
        var datesArray = Array(journeysGroupedByDate.keys)
        datesArray = datesArray.sorted{
            
            guard let param1 = journeysGroupedByDate[$0]?[0],
                let param2 = journeysGroupedByDate[$1]?[0],
                let timestamp1 = param1.datetime?.timestamp,
                let timestamp2 = param2.datetime?.timestamp
                else {
                    return false
            }
            
            return timestamp1 < timestamp2
        }
        return datesArray
    }
}
