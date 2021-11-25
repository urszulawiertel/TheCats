//
//  ViewController.swift
//  TheCats
//
//  Created by Ula on 22/11/2021.
//

import UIKit

class CatFactsViewController: UITableViewController {
    private var catFacts: [CatFacts] = []
    private let apiController: CatFactsAPIControlling = CatFactsAPIController()
    private let activityIndicator = UIActivityIndicatorView()
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cats Facts"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(downloadFacts))

        activityIndicator.style = .large
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }

    @objc func downloadFacts() {
        activityIndicator.startAnimating()

        apiController.fetchFacts { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let catFacts):
                self.catFacts = catFacts
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
        return catFacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CatFactsTableViewCell", for: indexPath) as? CatFactsTableViewCell else {
            fatalError("Unable to dequeue Table View Cells")
        }
        let item = catFacts[indexPath.row]
        let factNumber = indexPath.row + 1
        cell.configureCell(for: item, at: factNumber)
        return cell
    }

    private func addAlertController(message: String) {
        let alertController = UIAlertController(title: "Something went wrong!", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
