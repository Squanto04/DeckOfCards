//
//  PileLogTableViewCell.swift
//  Deck Of Cards
//
//  Created by Jordan Lamb on 10/4/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import UIKit

class PileLogTableViewCell: UITableViewCell {

    @IBOutlet weak var cardLogImageView: UIImageView!
    @IBOutlet weak var cardValueLabel: UILabel!

    var cardItem: Card? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let item = cardItem else { return }
        cardValueLabel.text = "\(item.value) \(item.suit)"
        cardLogImageView.image = nil
        guard let image = item.image else { return }
        CardController.getImage(forURL: image) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self.cardLogImageView.image = image
            }
        }
    }
}
