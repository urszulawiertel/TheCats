//
//  AnimalFact.swift
//  TheCats
//
//  Created by Ula on 22/11/2021.
//

import Foundation

struct AnimalFact: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case status
        case text
        case type
        case createdAt
    }
    let id: String
    let status: Status
    let text: String
    let type: String
    let createdAt: String?
}

struct Status: Codable {
    enum CodingKeys: String, CodingKey {
        case verified
    }
    let verified: Bool?
}
