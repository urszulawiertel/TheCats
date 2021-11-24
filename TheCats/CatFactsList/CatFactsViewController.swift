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
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cats Facts"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(downloadFacts))

        downloadFacts()
    }

    @objc func downloadFacts() {
        apiController.fetchFacts { result in
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

        cell.setupCell(for: item, at: indexPath.row)
        return cell
    }

    private func addAlertController(message: String) {
        let alertController = UIAlertController(title: "Something went wrong!", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
