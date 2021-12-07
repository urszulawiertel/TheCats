//
//  FavoritesTableViewController.swift
//  TheCats
//
//  Created by Ula on 05/12/2021.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    private var favorites: [AnimalFact] = []
    private let defaultsManager: UserDefaultsManaging = UserDefaultsManager()
    private let dateConverter: DateConverter = DateConverter(inputDateFormatter: .defaultDateFormatter,
                                              outputDateFormatter: .dayMonthYearDateFormatter)
    private let emptyFavoritesMessageLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Favorites"
        setupMessageLabel()
        favorites = defaultsManager.retrieveFavorites()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        favorites = defaultsManager.retrieveFavorites()
        showMessageLabel()
        tableView.reloadData()
    }

    private func showMessageLabel() {
        if favorites.isEmpty {
            emptyFavoritesMessageLabel.isHidden = false
        } else {
            emptyFavoritesMessageLabel.isHidden = true
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalFactsTableViewCell", for: indexPath) as? AnimalFactsTableViewCell else {
            fatalError("Unable to dequeue Table View Cells")
        }

        let item = favorites[indexPath.row]

        cell.selectionStyle = .none
        let tableViewCellViewModel = AnimalFactsTableViewCellViewModel(item: item)

        cell.viewModel = tableViewCellViewModel

        cell.viewModel.item?.index = (indexPath.row + 1)
        cell.configureCell(for: item, dateConverter: dateConverter)

        cell.viewModel.deleteButtonClicked = { [weak self] id in
            guard let self = self else { return }
            self.favorites.removeAll(where: { $0.id == id })
            self.showMessageLabel()
            self.tableView.reloadData()
        }

        return cell
    }

    private func setupMessageLabel() {
        emptyFavoritesMessageLabel.numberOfLines = 0
        emptyFavoritesMessageLabel.textAlignment = .center
        emptyFavoritesMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyFavoritesMessageLabel.isHidden = true
        emptyFavoritesMessageLabel.text = "No favorites saved."
        view.addSubview(emptyFavoritesMessageLabel)

        NSLayoutConstraint.activate([
            emptyFavoritesMessageLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            emptyFavoritesMessageLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            emptyFavoritesMessageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
