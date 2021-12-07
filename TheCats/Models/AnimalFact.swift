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
    var isFavorited: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case status
        case text
        case type
        case createdAt
        case index
        case isFavorited
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        status = try container.decode(Status.self, forKey: .status)
        text = try container.decode(String.self, forKey: .text)
        type = (try? container.decode(AnimalType.self, forKey: .type)) ?? .unspecified
        createdAt = try? container.decode(String.self, forKey: .createdAt)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(status, forKey: .status)
        try container.encode(text, forKey: .text)
        try container.encode(type, forKey: .type)
        try container.encode(createdAt, forKey: .createdAt)
    }
}

struct Status: Codable {
    let verified: Bool?

    enum CodingKeys: String, CodingKey {
        case verified
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(verified, forKey: .verified)
    }
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
