//
//  Airport.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-10-17.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// Represents information about an airport
public struct Airport: Decodable, Equatable {
    /// IATA code
    public let code: String
    /// Airport name
    public let name: String
    /// City
    public let city: String
    /// Timezone
    public let timeZone: TimeZone

    enum CodingKeys: String, CodingKey {
        case code = "iata"
        case name = "name"
        case city = "city"
        case utcOffsetHours = "utcOffsetHours"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.name = try container.decode(String.self, forKey: .name)
        self.city = try container.decode(String.self, forKey: .city)

        let utcOffsetHours = try container.decode(String.self, forKey: .utcOffsetHours)

        guard let timeZone = TimeZone(with: utcOffsetHours) else {
            throw DecodingError.dataCorruptedError(forKey: .utcOffsetHours, in: container, debugDescription: "Wrong format for UTC offset hours")
        }
        self.timeZone = timeZone
    }
}
