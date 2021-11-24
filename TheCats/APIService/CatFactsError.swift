//
//  CatFactsError.swift
//  TheCats
//
//  Created by Ula on 24/11/2021.
//

import Foundation

enum CatFactsError: Error {
    case serverResponse(HTTPURLResponse)
    case urlSession(Error)
    case unknown
    case decodingError

    var errorMessage: String {
        switch self {
        case .serverResponse:
            return "Server Error. Please try again later."
        case .urlSession:
            return "Check your internet connection and reconnect."
        case .unknown:
            return "Please try again later or let us know if the issue persists."
        case .decodingError:
            return "Please try again later."
        }
    }
}
