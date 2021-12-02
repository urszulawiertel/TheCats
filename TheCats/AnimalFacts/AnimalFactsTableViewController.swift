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
    private let activityIndicator = UIActivityIndicatorView()
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Animal Facts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(downloadFacts))

        activityIndicator.style = .large
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)

        navigationItem.searchController = searchController
        searchController.delegate = self
        searchController.searchResultsUpdater = self
    }

    @objc func downloadFacts() {
        animalFacts = []
        animalFactsFiltered = []
        tableView.reloadData()
        activityIndicator.startAnimating()

        apiController.fetchFacts(forType: defaultsManager.getAnimalType(),
                                 forNumber: Int(defaultsManager.getFactsNumber()) ?? 1) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let animalFacts):
                self.animalFacts = animalFacts
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

        let cellTitle = "Fact #\(indexPath.row + 1):"

        var item: AnimalFact
        if !animalFactsFiltered.isEmpty {
            item = animalFactsFiltered[indexPath.row]
        } else {
            item = animalFacts[indexPath.row]
        }

        cell.configureCell(for: item, withTitle: cellTitle)
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
