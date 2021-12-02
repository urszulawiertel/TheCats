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
}

struct UserDefaultsManager: UserDefaultsManaging {

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = UserDefaults()) {
        self.userDefaults = userDefaults
    }

    private enum Keys: String {
        case factsKey = "factsNumber"
        case animalKey = "animalType"
    }

    func setFactsNumber(value: String?) {
        return userDefaults.set(value, forKey: Keys.factsKey.rawValue)
    }

    func setAnimalType(value: String?) {
        return userDefaults.set(value, forKey: Keys.animalKey.rawValue)
    }

    func getFactsNumber() -> String {
        return userDefaults.string(forKey: Keys.factsKey.rawValue) ?? ""
    }

    func getAnimalType() -> String {
        return userDefaults.string(forKey: Keys.animalKey.rawValue) ?? ""
    }

}
