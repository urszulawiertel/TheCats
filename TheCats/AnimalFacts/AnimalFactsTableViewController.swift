//
//  ViewController.swift
//  TheCats
//
//  Created by Ula on 22/11/2021.
//

import UIKit

class AnimalFactsTableViewController: UITableViewController {
    private var animalFacts: [AnimalFact] = []
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
    }

    @objc func downloadFacts() {
        animalFacts = []
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
                    self.addAlertController(message: error.errorMessage)
                }
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animalFacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalFactsTableViewCell", for: indexPath) as? AnimalFactsTableViewCell else {
            fatalError("Unable to dequeue Table View Cells")
        }
        let item = animalFacts[indexPath.row]
        let cellTitle = "Fact #\(indexPath.row + 1):"
        cell.configureCell(for: item, withTitle: cellTitle)
        return cell
    }

    private func addAlertController(message: String) {
        let alertController = UIAlertController(title: "Something went wrong!", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
