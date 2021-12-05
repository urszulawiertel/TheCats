//
//  AnimalFact.swift
//  TheCats
//
//  Created by Ula on 22/11/2021.
//

import Foundation

struct AnimalFact: Codable {
    let id: String
    let status: Status
    let text: String
    let type: AnimalType
    let createdAt: String?
    // It's not returned from the server and it's used to preserve facts order
    var index: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case status
        case text
        case type
        case createdAt
        case index
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        status = try container.decode(Status.self, forKey: .status)
        text = try container.decode(String.self, forKey: .text)
        type = (try? container.decode(AnimalType.self, forKey: .type)) ?? .unspecified
        createdAt = try? container.decode(String.self, forKey: .createdAt)
    }
}

struct Status: Codable {
    let verified: Bool?
}

enum AnimalType: String, CaseIterable, Codable {
    case cat
    case dog
    case horse
    case snail
    case unspecified

    var animalEmoji: String {
        switch self {
        case .cat:
            return "🐈‍⬛"
        case .dog:
            return "🐕"
        case .horse:
            return "🐎"
        case .snail:
            return "🐌"
        case .unspecified:
            return "🐾"
        }
    }

    var displayName: String {
        "\(self.animalEmoji) \(self.rawValue.capitalized)"
    }
}
