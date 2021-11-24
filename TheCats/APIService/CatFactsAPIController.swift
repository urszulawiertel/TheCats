//
//  CatFactsAPIController.swift
//  TheCats
//
//  Created by Ula on 22/11/2021.
//

import Foundation

protocol CatFactsAPIControlling {
    func fetchFacts(completionHandler: @escaping (Result<[CatFacts], CatFactsError>) -> Void)
}

struct CatFactsAPIController: CatFactsAPIControlling {

    private let baseUrl = "https://cat-fact.herokuapp.com/facts/random?animal_type=cat&amount=10"

    private func fetchData(for url: URL, completionHandler: @escaping (Result<[CatFacts], CatFactsError>) -> Void) {

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
                let decoded = try JSONDecoder().decode([CatFacts].self, from: data)
                completionHandler(.success(decoded))
            } catch {
                completionHandler(.failure(.decodingError))
            }
        }
        task.resume()
    }

    func fetchFacts(completionHandler: @escaping (Result<[CatFacts], CatFactsError>) -> Void) {
        guard let url = URL(string: baseUrl) else { return }

        fetchData(for: url, completionHandler: completionHandler)
    }

}
