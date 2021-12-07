//
//  AnimalFactsTableViewCell.swift
//  TheCats
//
//  Created by Ula on 23/11/2021.
//

import UIKit

struct AnimalFactsTableViewCellViewModel {
    var item: AnimalFact?
    let defaultsManager: UserDefaultsManaging
    var favoriteButtonClicked: ((String, Bool) -> Void)?
    var deleteButtonClicked: ((String) -> Void)?

    init(item: AnimalFact?,
         defaultsManager: UserDefaultsManaging = UserDefaultsManager()) {
        self.item = item
        self.defaultsManager = defaultsManager
    }
}

class AnimalFactsTableViewCell: UITableViewCell {
    @IBOutlet private weak var prefixLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton?
    @IBOutlet weak var deleteButton: UIButton?

    var viewModel: AnimalFactsTableViewCellViewModel!

    func configureCell(for model: AnimalFact?, dateConverter: DateConverting) {
        prefixLabel.text = "Fact #\(viewModel.item?.index ?? 1):"
        contentLabel.text = viewModel.item?.text
        typeLabel.text = viewModel.item?.type.animalEmoji
        dateLabel.text = "Created at:\n\(dateConverter.formatDate(viewModel.item?.createdAt ?? "") ?? "")"
        favoriteButton?.isSelected = viewModel.item?.isFavorited ?? false
    }

    @IBAction private func favoriteButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()

        guard let id = viewModel.item?.id else { return }
        viewModel.favoriteButtonClicked?(id, sender.isSelected)
        if sender.isSelected {
            guard let unwrappedItem = viewModel.item else { return }
            viewModel.defaultsManager.saveFavorite(item: unwrappedItem)
        } else {
            viewModel.defaultsManager.deleteFavorites(itemsIds: [id])
        }
    }

    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        guard let id = viewModel.item?.id else { return }
        viewModel.deleteButtonClicked?(id)
        viewModel.defaultsManager.deleteFavorites(itemsIds: [id])
    }
}
