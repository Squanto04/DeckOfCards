//
//  CardsViewController.swift
//  Deck Of Cards
//
//  Created by Jordan Lamb on 10/3/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController {
    
    @IBOutlet weak var newCardImageView: UIImageView!
    @IBOutlet weak var firstCardImageView: UIImageView!
    @IBOutlet weak var secondCardImageView: UIImageView!
    @IBOutlet weak var thirdCardImageView: UIImageView!
    @IBOutlet weak var drawNewCardButton: UIButton!
    @IBOutlet weak var topWarningLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(DeckController.currentDeckID)
        designCardImageViews()
        enableDrawCardButton()
    }
    
    @IBAction func setCurrentDeckIDButton(_ sender: Any) {
        DeckController.currentDeckID = "ufl28o8bm2wi"
        print(DeckController.currentDeckID)
        enableDrawCardButton()
    }
    
    @IBAction func pauseButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Menu", message: "", preferredStyle: .actionSheet)
        let newDeckAction = UIAlertAction(title: "New Deck", style: .default) { (_) in
            DeckController.newDeckWith(count: 1, completion: { (deck) in
                DispatchQueue.main.async {
                    self.enableDrawCardButton()
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) in
        }
        
        let shuffleAction = UIAlertAction(title: "Shuffle", style: .default) { (_) in
            DeckController.shuffleCards(deckId: DeckController.currentDeckID, completion: {
            })
            PileController.addCardsBackToDeck(for: DeckController.currentDeckID, pile: PileController.leftInPile, completion: {
            })
        }
        let cardLogAction = UIAlertAction(title: "Card Log", style: .default) { (_) in
            self.performSegue(withIdentifier: "toCardLogVC", sender: self)
        }
        alert.addAction(newDeckAction)
        alert.addAction(shuffleAction)
        alert.addAction(cardLogAction)
        alert.addAction(cancelAction)
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func drawNewCardButtonTapped(_ sender: Any) {
        drawCard()
        setCardHistory()
    }
    
    func drawCard() {
        CardController.drawCard(numberOfCards: 1, with: DeckController.currentDeckID) { (cards) in
            let card = cards[0]
            guard let image = card.image else { return }
            CardController.getImage(forURL: image, completion: { (image) in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    self.newCardImageView.image = image
                }
                PileController.addCardToPile(deck: DeckController.currentDeckID, card: card, completion: {
                    print("Card Added to Discard Pile")
                })
            })
        }
    }
    
    func setCardHistory() {
        PileController.listCardsInPile(deck: DeckController.currentDeckID) { (cards) in
            guard let cardSlotOne = cards[1].image else { return }
            if !cardSlotOne.isEmpty {
                CardController.getImage(forURL: cardSlotOne, completion: { (image) in
                    guard let image = image else { return }
                    DispatchQueue.main.async {
                        self.firstCardImageView.image = image
                    }
                })
            }
            guard let cardSlotTwo = cards[2].image else { return }
            if !cardSlotTwo.isEmpty {
                CardController.getImage(forURL: cardSlotTwo, completion: { (image) in
                    guard let image = image else { return }
                    DispatchQueue.main.async {
                        self.secondCardImageView.image = image
                    }
                })
            }
            guard let cardSlotThree = cards[3].image else { return }
            if !cardSlotThree.isEmpty {
                CardController.getImage(forURL: cardSlotThree, completion: { (image) in
                    guard let image = image else { return }
                    DispatchQueue.main.async {
                        self.thirdCardImageView.image = image
                    }
                })
            }
        }
    }
    
    func enableDrawCardButton() {
        if DeckController.currentDeckID == "" {
            topWarningLabel.text = "Select 'New Deck' in the Menu to start!"
            drawNewCardButton.isEnabled = false
        } else {
            drawNewCardButton.setImage(UIImage(named: "RedBack"), for: .normal)
            drawNewCardButton.isEnabled = true
            topWarningLabel.isHidden = true
        }
    }
    
    // MARK: - Design Functions
    
    func designCardImageViews() {
        drawNewCardButton.layer.borderWidth = 1
        drawNewCardButton.layer.cornerRadius = 12
        newCardImageView.layer.borderWidth = 1
        newCardImageView.layer.cornerRadius = 12
        firstCardImageView.layer.borderWidth = 1
        firstCardImageView.layer.cornerRadius = 12
        secondCardImageView.layer.borderWidth = 1
        secondCardImageView.layer.cornerRadius = 12
        thirdCardImageView.layer.borderWidth = 1
        thirdCardImageView.layer.cornerRadius = 12
    }

}
