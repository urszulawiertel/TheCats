//
//  AnimalFactsTableViewCell.swift
//  TheCats
//
//  Created by Ula on 23/11/2021.
//

import UIKit

class AnimalFactsTableViewCell: UITableViewCell {
    @IBOutlet private weak var prefixLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!

    func configureCell(for model: AnimalFact?, dateFormatter: DateConverting) {
        prefixLabel.text = "Fact #\(model?.index ?? 1):"
        contentLabel.text = model?.text
    }
}
