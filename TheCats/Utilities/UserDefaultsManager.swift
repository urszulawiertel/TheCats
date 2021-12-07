//
//  UserDefaultsManager.swift
//  TheCats
//
//  Created by Ula on 01/12/2021.
//

import Foundation

protocol UserDefaultsManaging {
    func setFactsNumber(value: String?)
    func setAnimalType(value: String?)
    func getFactsNumber() -> String
    func getAnimalType() -> String
    func saveFavorite(item: AnimalFact)
    func retrieveFavorites() -> [AnimalFact]
    func deleteFavorites(itemsIds: [String])
}

struct UserDefaultsManager: UserDefaultsManaging {

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = UserDefaults()) {
        self.userDefaults = userDefaults
    }

    private enum Keys: String {
        case factsKey = "factsNumber"
        case animalKey = "animalType"
        case favoritesKey = "favorites"
    }

    func setFactsNumber(value: String?) {
        userDefaults.set(value, forKey: Keys.factsKey.rawValue)
    }

    func setAnimalType(value: String?) {
        userDefaults.set(value, forKey: Keys.animalKey.rawValue)
    }

    func getFactsNumber() -> String {
        return userDefaults.string(forKey: Keys.factsKey.rawValue) ?? ""
    }

    func getAnimalType() -> String {
        return userDefaults.string(forKey: Keys.animalKey.rawValue) ?? ""
    }

    func saveFavorite(item: AnimalFact) {
        var items = retrieveFavorites()
        items.append(item)
        guard let encodedData = try? JSONEncoder().encode(items) else { return }
        userDefaults.set(encodedData, forKey: Keys.favoritesKey.rawValue)
    }

    func deleteFavorites(itemsIds: [String]) {
        var items = retrieveFavorites()

        for itemId in itemsIds {
            var localIndex: Int = 0
            for (index, item) in items.enumerated() where item.id == itemId {
                localIndex = index
                items.remove(at: localIndex)
            }
        }

        guard let encodedData = try? JSONEncoder().encode(items) else { return }
        userDefaults.removeObject(forKey: Keys.favoritesKey.rawValue)
        userDefaults.set(encodedData, forKey: Keys.favoritesKey.rawValue)
    }

    func retrieveFavorites() -> [AnimalFact] {
        guard let data = userDefaults.data(forKey: Keys.favoritesKey.rawValue), let decodedData = try? JSONDecoder().decode([AnimalFact].self, from: data) else { return [] }
        return decodedData
    }
}
