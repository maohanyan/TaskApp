//
//  Location.swift
//  TaskApp
//
//  Created by Mariam Ohanyan on 02.08.22.
//

import Foundation

struct Loaction: Decodable {
    var street: Street
    var city: String
    var state: String
    var country: String
    var postcode: String
    var coordinates: Coordinates
    var timezone: Timezone
    
    private enum CodingKeys: String, CodingKey {
        case street, city, state, country, postcode, coordinates, timezone
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        street = try container.decode(Street.self, forKey: .street)
        city = try container.decode(String.self, forKey: .city)
        state = try container.decode(String.self, forKey: .state)
        country = try container.decode(String.self, forKey: .country)
        do {
            postcode = String(try container.decode(Int.self, forKey: .postcode))
        } catch DecodingError.typeMismatch {
            postcode = try container.decode(String.self, forKey: .postcode)
        }
        coordinates = try container.decode(Coordinates.self, forKey: .coordinates)
        timezone = try container.decode(Timezone.self, forKey: .timezone)
    }
}

struct Street: Decodable {
    var number: Int
    var name: String
}

struct Timezone: Decodable {
    var offset: String
    var description: String
}

struct Coordinates: Decodable {
    var lat: String
    var lng: String
    
    private enum CodingKeys: String, CodingKey {
        case lat = "latitude"
        case lng = "longitude"
    }
}
