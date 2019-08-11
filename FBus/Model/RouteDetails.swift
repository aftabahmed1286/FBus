//
//  RouteDetails.swift
//  FB
//
//  Created by Aftab Ahmed on 7/17/19.
//  Copyright © 2019 FAMCO. All rights reserved.
//

import Foundation

struct RouteDetails: Codable {
    
    var id: Int?
    var name: String?
    var default_address: Address?
    var address: String?
    var full_address: String?
    var coordinates: Coordinates?
    
    enum CodingKeys: String, CodingKey {
        case id, name, default_address, address, full_address, coordinates
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.default_address = try container.decodeIfPresent(Address.self, forKey: .default_address)
        self.address = try container.decodeIfPresent(String.self, forKey: .address)
        self.full_address = try container.decodeIfPresent(String.self, forKey: .full_address)
        self.coordinates = try container.decodeIfPresent(Coordinates.self, forKey: .coordinates)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.default_address, forKey: .default_address)
        try container.encode(self.address, forKey: .address)
        try container.encode(self.full_address, forKey: .full_address)
        try container.encode(self.coordinates, forKey: .coordinates)
    }
}
