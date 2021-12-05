//
//  ViewController.swift
//  TheCats
//
//  Created by Ula on 22/11/2021.
//

import UIKit

class AnimalFactsTableViewController: UITableViewController {
    private var animalFacts: [AnimalFact] = []
    private var animalFactsFiltered = [AnimalFact]()
    private let apiController: AnimalFactsAPIControlling = AnimalFactsAPIController()
    private let defaultsManager: UserDefaultsManaging = UserDefaultsManager()
    private let dateConverter: DateConverter = DateConverter(inputDateFormatter: .defaultDateFormatter,
                                              outputDateFormatter: .dayMonthYearDateFormatter)
    private let activityIndicator = UIActivityIndicatorView()
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Animal Facts"

        setupRightBarButtonItems()

        activityIndicator.style = .large
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)

        navigationItem.searchController = searchController
        searchController.delegate = self
        searchController.searchResultsUpdater = self
    }

    private func setupRightBarButtonItems() {
        let barButtonMenu = UIMenu(title: "Sort by", options: .displayInline, children: [
            UIAction(title: "Date", image: UIImage(systemName: "calendar.badge.clock"), handler: sortFacts),
            UIAction(title: "Type", image: UIImage(systemName: "pencil"), handler: sortFacts),
            UIAction(title: "Alphabetical", image: UIImage(systemName: "textformat.abc"), handler: sortFacts),
            UIAction(title: "Verified", image: UIImage(systemName: "checkmark.circle"), handler: sortFacts)
        ])

        let downloadBarItem = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(downloadFacts))
        let filterBarItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), menu: barButtonMenu)
        navigationItem.rightBarButtonItems = [filterBarItem, downloadBarItem]
    }

    private func sortFacts(action: UIAction) {
        switch action.title {
        case "Date":
            let now = Date()
            animalFactsFiltered = animalFacts.sorted {
                dateConverter.getDate($0.createdAt ?? "") ?? now > dateConverter.getDate($1.createdAt ?? "") ?? now
            }
        case "Type":
            animalFactsFiltered = animalFacts.sorted { $0.type.rawValue < $1.type.rawValue }
        case "Alphabetical":
            animalFactsFiltered = animalFacts.sorted { $0.text < $1.text }
        case "Verified":
            animalFactsFiltered = animalFacts.sorted { $0.status.verified ?? false && !($1.status.verified ?? false) }
        default:
            return
        }
        tableView.reloadData()
    }

    @objc private func downloadFacts() {
        animalFacts = []
        animalFactsFiltered = []
        tableView.reloadData()
        activityIndicator.startAnimating()

        apiController.fetchFacts(forType: AnimalType(rawValue: defaultsManager.getAnimalType()) ?? .unspecified,
                                 forNumber: Int(defaultsManager.getFactsNumber()) ?? 1) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let animalFacts):
                self.animalFacts = animalFacts
                animalFacts.enumerated().forEach { self.animalFacts[$0.offset].index = $0.offset + 1 }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlertController(message: error.errorMessage)
                }
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !animalFactsFiltered.isEmpty {
            return animalFactsFiltered.count
        }
        return searchController.isActive ? 0 : animalFacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalFactsTableViewCell", for: indexPath) as? AnimalFactsTableViewCell else {
            fatalError("Unable to dequeue Table View Cells")
        }

        var item: AnimalFact
        if !animalFactsFiltered.isEmpty {
            item = animalFactsFiltered[indexPath.row]
        } else {
            item = animalFacts[indexPath.row]
        }

        cell.selectionStyle = .none
        cell.configureCell(for: item, dateConverter: dateConverter)
        return cell
    }

    private func showAlertController(message: String) {
        let alertController = UIAlertController(title: "Something went wrong!", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

// MARK: - UISearchControllerDelegate

extension AnimalFactsTableViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces).lowercased() else {
            return
        }

        if searchText.isEmpty {
            animalFactsFiltered = animalFacts
        } else {
            let searchResults = animalFacts.filter { $0.text.lowercased().contains(searchText) }
            animalFactsFiltered = searchResults
        }
        tableView.reloadData()
    }
}
