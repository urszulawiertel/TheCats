//
//  CatFactsAPIController.swift
//  TheCats
//
//  Created by Ula on 22/11/2021.
//

import Foundation

protocol CatFactsAPIControlling {
    func fetchData(for url: URL, completionHandler: @escaping (Result<[CatFacts], Error>) -> Void)
}

struct CatFactsAPIController {
    let baseUrl = "https://cat-fact.herokuapp.com/facts/random?animal_type=cat&amount=10"

    private func fetchData(for url: URL, completionHandler: @escaping (Result<[CatFacts], Error>) -> Void) {

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse else {
                return
            }

            guard (200...299).contains(response.statusCode) else {
                return
            }

            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode([CatFacts].self, from: data)
                completionHandler(.success(decoded))
            } catch {
                print(error)
            }
        }
        task.resume()
    }

    func fetchFacts(completionHandler: @escaping (Result<[CatFacts], Error>) -> Void) {
        guard let url = URL(string: baseUrl) else { return }

        fetchData(for: url, completionHandler: completionHandler)
    }

}
