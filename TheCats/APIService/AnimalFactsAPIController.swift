//
//  AnimalFactsAPIController.swift
//  TheCats
//
//  Created by Ula on 22/11/2021.
//

import Foundation

protocol AnimalFactsAPIControlling {
    func fetchFacts(forType type: AnimalType, forNumber number: Int, completionHandler: @escaping (Result<[AnimalFact], AnimalFactsError>) -> Void)
}

extension AnimalType {
    /// Retrieves the raw value from AnimalType cases and converts it to a query value
    /// - Returns: Returns a query string
    func getQueryValue() -> String {
        switch self {
        case .unspecified:
            var allCases = AnimalType.allCases
            allCases.removeAll { $0 == .unspecified }
            let allCasesQueryString = allCases.map { $0.rawValue }.joined(separator: ",")
            return allCasesQueryString
        default:
            return self.rawValue
        }
    }
}

struct AnimalFactsAPIController: AnimalFactsAPIControlling {

    private struct Constants {
        static var components: URLComponents {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "cat-fact.herokuapp.com"
            return components
        }
    }

    private func decode<T: Decodable>(_ model: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.defaultDateFormatter)
        let decodedData = try decoder.decode(model.self, from: data)
        return decodedData
    }

    func fetchFacts(forType type: AnimalType, forNumber number: Int, completionHandler: @escaping (Result<[AnimalFact], AnimalFactsError>) -> Void) {

        var components = Constants.components
        components.path = "/facts/random"
        components.queryItems = [
            URLQueryItem(name: "animal_type", value: type.getQueryValue()),
            URLQueryItem(name: "amount", value: "\(number)")
        ]

        guard let url = components.url else { return }

        fetchData(withUrl: url, forNumber: number, completionHandler: completionHandler)
    }

    private func fetchData<T: Decodable>(withUrl url: URL, forNumber factsNumber: Int, completionHandler: @escaping (Result<[T], AnimalFactsError>) -> Void) {

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(.failure(.urlSession(error)))
            }

            guard let data = data, let response = response as? HTTPURLResponse else {
                return completionHandler(.failure(.unknown))
            }

            guard (200...299).contains(response.statusCode) else {
                return completionHandler(.failure(.serverResponse(response)))
            }

            do {
                let decoded: [T]
                if factsNumber == 1 {
                    decoded = try [decode(T.self, from: data)]
                } else {
                    decoded = try decode([T].self, from: data)
                }
                completionHandler(.success(decoded))

            } catch {
                completionHandler(.failure(.decodingError))
            }
        }
        task.resume()
    }
}
