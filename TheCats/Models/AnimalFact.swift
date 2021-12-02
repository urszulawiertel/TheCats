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
    let type: String
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case status
        case text
        case type
        case createdAt
    }
}

struct Status: Codable {
    let verified: Bool?

    enum CodingKeys: String, CodingKey {
        case verified
    }
}
