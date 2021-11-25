//
//  CatFactsTableViewCell.swift
//  TheCats
//
//  Created by Ula on 23/11/2021.
//

import UIKit

class CatFactsTableViewCell: UITableViewCell {
    @IBOutlet private weak var prefixLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!

    func configureCell(for model: CatFacts?, at number: Int) {
        prefixLabel.text = "Fact #\(number):"
        contentLabel.text = model?.text
    }
}
