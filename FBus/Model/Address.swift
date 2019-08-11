//
//  Address.swift
//  FB
//
//  Created by Aftab Ahmed on 7/17/19.
//  Copyright © 2019 FAMCO. All rights reserved.
//

import Foundation

struct Address: Codable {
    
    var address: String?
    var full_address: String?
    var coordinates: Coordinates?
    
    enum CodingKeys: String, CodingKey {
        case address, full_address, coordinates
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address = try container.decodeIfPresent(String.self, forKey: .address)
        self.full_address = try container.decodeIfPresent(String.self, forKey: .full_address)
        self.coordinates = try container.decodeIfPresent(Coordinates.self, forKey: .coordinates)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.address, forKey: .address)
        try container.encode(self.full_address, forKey: .full_address)
        try container.encode(self.coordinates, forKey: .coordinates)
    }
}
