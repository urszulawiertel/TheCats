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
}

struct Status: Codable {
    let verified: Bool?
}
