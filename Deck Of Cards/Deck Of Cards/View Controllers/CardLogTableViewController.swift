//
//  CardLogTableViewController.swift
//  Deck Of Cards
//
//  Created by Jordan Lamb on 10/4/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import UIKit

class CardLogTableViewController: UITableViewController {
    
    @IBOutlet weak var cardsLeftInDeck: UILabel!
    
    var pile: [Card] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        PileController.listCardsInPile(deck: DeckController.currentDeckID) { (cards) in
            self.pile = cards.reversed()
            DispatchQueue.main.async {
                self.cardsLeftInDeck.text = "Cards Left In Deck: \(PileController.leftInDeck)"
            }
        }
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pile.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cardLogCell", for: indexPath) as? PileLogTableViewCell else {
            print("Error casting PileLogTableViewCell")
            return UITableViewCell()}
        cell.cardItem = pile[indexPath.row]
        return cell
    }

}
