//
//  SettingsViewController.swift
//  TheCats
//
//  Created by Ula on 26/11/2021.
//

import UIKit

class SettingsViewController: UIViewController {
    // MARK: - Properties

    @IBOutlet private weak var factsNumberLabel: UILabel!
    @IBOutlet private weak var animalTypeLabel: UILabel!
    @IBOutlet private weak var factsNumberTextField: UITextField!
    @IBOutlet private weak var animalTypeTextField: UITextField!
    @IBOutlet private weak var doneButton: UIButton!

    private var factsNumberPickerView = UIPickerView()
    private var animalTypePickerView = UIPickerView()

    // MARK: - Constants

    private let factsNumber: [Int] = Array(1...10)
    private let userDefaults = UserDefaults(suiteName: "group.com.TheCats.app")
    private let animalTypes = AnimalType.allCases

    // MARK: - Types

    private enum Keys: String {
        case factsKey = "factsNumber"
        case animalKey = "animalType"
    }

    private enum AnimalType: CaseIterable {
        case cat
        case dog
        case horse
        case snail

        var animalEmoji: String {
            switch self {
            case .cat:
                return "🐈‍⬛"
            case .dog:
                return "🐕"
            case .horse:
                return "🐎"
            case .snail:
                return "🐌"
            }
        }
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Settings"

        setupTextField()
        setupPickerView()
    }

    // MARK: - Setup

    private func setupPickerView() {
        factsNumberPickerView.dataSource = self
        factsNumberPickerView.delegate = self
        animalTypePickerView.dataSource = self
        animalTypePickerView.delegate = self

        factsNumberPickerView.tag = 1
        animalTypePickerView.tag = 2
    }

    private func setupTextField() {
        factsNumberTextField.inputView = factsNumberPickerView
        animalTypeTextField.inputView = animalTypePickerView

        factsNumberTextField.text = userDefaults?.string(forKey: Keys.factsKey.rawValue)
        animalTypeTextField.text = userDefaults?.string(forKey: Keys.animalKey.rawValue)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if factsNumberTextField.isEditing {
            factsNumberTextField.resignFirstResponder()
        } else if animalTypeTextField.isEditing {
            animalTypeTextField.resignFirstResponder()
        }
    }
}

// MARK: - UIPickerViewDelegate

extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return factsNumber.count
        case 2:
            return animalTypes.count
        default:
            return 1
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        switch pickerView.tag {
        case 1:
            return "\(factsNumber[row])"
        case 2:
            return "\(animalTypes[row].animalEmoji)"
        default:
            return ""
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            factsNumberTextField.text = "\(factsNumber[row])"
            userDefaults?.set(factsNumberTextField.text, forKey: Keys.factsKey.rawValue)
        case 2:
            animalTypeTextField.text = "\(animalTypes[row])"
            userDefaults?.set(animalTypeTextField.text, forKey: Keys.animalKey.rawValue)
        default:
            return
        }
    }
}
