//
//  CatFactsTableViewCell.swift
//  TheCats
//
//  Created by Ula on 23/11/2021.
//

import UIKit

class CatFactsTableViewCell: UITableViewCell {
    @IBOutlet weak var prefixLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    func setupCell(for row: CatFacts?, at index: Int) {
        prefixLabel.text = "Fact \(index + 1):"
        contentLabel.text = row?.text
    }
}
