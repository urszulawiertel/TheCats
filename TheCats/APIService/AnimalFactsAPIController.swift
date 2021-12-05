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

    private let baseUrl = "https://cat-fact.herokuapp.com/"

    func fetchFacts(forType type: AnimalType, forNumber number: Int, completionHandler: @escaping (Result<[AnimalFact], AnimalFactsError>) -> Void) {

        guard let url = URL(string: "\(baseUrl)facts/random?animal_type=\(type.getQueryValue())&amount=\(number)") else { return }

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
                    decoded = try [JSONDecoder().decode(T.self, from: data)]
                } else {
                    decoded = try JSONDecoder().decode([T].self, from: data)
                }
                completionHandler(.success(decoded))

            } catch {
                completionHandler(.failure(.decodingError))
            }
        }
        task.resume()
    }
}
