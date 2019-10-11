//
//  CardsViewController.swift
//  Deck Of Cards
//
//  Created by Jordan Lamb on 10/3/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController {
    
    // Image Outlets
    @IBOutlet weak var newCardImageView: UIImageView!
    @IBOutlet weak var firstCardImageView: UIImageView!
    @IBOutlet weak var secondCardImageView: UIImageView!
    @IBOutlet weak var thirdCardImageView: UIImageView!
    // Button Outlets
    @IBOutlet weak var endOfDeckShuffleButton: UIButton!
    @IBOutlet weak var drawNewCardButton: UIButton!
    @IBOutlet weak var newDeckButton: UIButton!
    @IBOutlet weak var shuffleDeckButton: UIButton!
    @IBOutlet weak var cardLogButton: UIButton!
    @IBOutlet weak var cancelMenuButton: UIButton!
    // Label Outlets
    @IBOutlet weak var topWarningLabel: UILabel!
    // View Outlets
    @IBOutlet weak var pauseMenuView: UIView!
    @IBOutlet weak var areYouSureStackView: UIStackView!
    @IBOutlet weak var menuStackView: UIStackView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        designMenuView()
        designCardImageViews()
        enableDrawCardButton()
    }
    
    
    // MARK: - Menu Buttons
    @IBAction func pauseButtonTapped(_ sender: UIBarButtonItem) {
        pauseMenuView.isHidden = false
        drawNewCardButton.isEnabled = false
        if DeckController.currentDeckID == "" {
            shuffleDeckButton.isEnabled = false
            cardLogButton.isEnabled = false
        }
        enableNewDeckButton()
    }
    @IBAction func newDeckButtonTapped(_ sender: Any) {
        shuffleDeckButton.isEnabled = true
        cardLogButton.isEnabled = true
        pauseMenuView.isHidden = true
        DeckController.newDeckWith(count: 1) { (deck) in
            DispatchQueue.main.async {
                self.enableDrawCardButton()
            }
        }
    }
    @IBAction func shuffleDeckButtonTapped(_ sender: Any) {
        menuStackView.isHidden = true
        areYouSureStackView.isHidden = false
    }
        @IBAction func areYouSureYesButton(_ sender: Any) {
            DeckController.shuffleCards(deckId: DeckController.currentDeckID) {}
            PileController.addCardsBackToDeck(for: DeckController.currentDeckID, pile: PileController.leftInPile) {}
            areYouSureStackView.isHidden = true
            menuStackView.isHidden = false
            pauseMenuView.isHidden = true
            newCardImageView.image = nil
            firstCardImageView.image = nil
            secondCardImageView.image = nil
            thirdCardImageView.image = nil
            drawNewCardButton.isEnabled = true
        }
        @IBAction func areYouSureNoButton(_ sender: Any) {
            menuStackView.isHidden = false
            areYouSureStackView.isHidden = true
        }
    
    @IBAction func cardLogButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toCardLogVC", sender: self)
        pauseMenuView.isHidden = true
        drawNewCardButton.isEnabled = true
    }
    
    @IBAction func cancelMenuButtonTapped(_ sender: Any) {
        pauseMenuView.isHidden = true
        drawNewCardButton.isEnabled = true
    }
    
    @IBAction func setCurrentDeckIDButton(_ sender: Any) {
        DeckController.shuffleCards(deckId: DeckController.currentDeckID) {}
        endOfDeckShuffleButton.isHidden = true
        enableDrawCardButton()
        shuffleDeckButton.isEnabled = true
        cardLogButton.isEnabled = true
        newCardImageView.image = nil
        firstCardImageView.image = nil
        secondCardImageView.image = nil
        thirdCardImageView.image = nil
        PileController.discardCount = 0
    }
    
    @IBAction func drawNewCardButtonTapped(_ sender: Any) {
        drawCard()
        PileController.discardCount += 1
        setCardHistory()
        areThereCardsLeft()
    }
    
    // MARK: - Functions
    
    func drawCard() {
        print("Draw Card")
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
        print("Set Card History")
        PileController.listCardsInPile(deck: DeckController.currentDeckID) { (cards) in
            if PileController.discardCount == 2 {
                guard let cardSlotOne = PileController.cardsReversed[0].image else { return }
                CardController.getImage(forURL: cardSlotOne, completion: { (image) in
                    guard let image = image else { return }
                    DispatchQueue.main.async {
                        self.firstCardImageView.image = image
                    }
                })
            } else if PileController.discardCount == 3 {
                guard let cardSlotOne = PileController.cardsReversed[0].image else { return }
                CardController.getImage(forURL: cardSlotOne, completion: { (image) in
                    guard let image = image else { return }
                    DispatchQueue.main.async {
                        self.firstCardImageView.image = image
                    }
                })
                guard let cardSlotTwo = PileController.cardsReversed[1].image else { return }
                CardController.getImage(forURL: cardSlotTwo, completion: { (image) in
                    guard let image = image else { return }
                    DispatchQueue.main.async {
                        self.secondCardImageView.image = image
                    }
                })
            } else if PileController.discardCount >= 4 {
                guard let cardSlotOne = PileController.cardsReversed[0].image else { return }
                CardController.getImage(forURL: cardSlotOne, completion: { (image) in
                    guard let image = image else { return }
                    DispatchQueue.main.async {
                        self.firstCardImageView.image = image
                    }
                })
                guard let cardSlotTwo = PileController.cardsReversed[1].image else { return }
                CardController.getImage(forURL: cardSlotTwo, completion: { (image) in
                    guard let image = image else { return }
                    DispatchQueue.main.async {
                        self.secondCardImageView.image = image
                    }
                })
                guard let cardSlotThree = PileController.cardsReversed[2].image else { return }
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
    
    func areThereCardsLeft() {
        if PileController.discardCount == 52 {
            drawNewCardButton.isEnabled = false
            drawNewCardButton.setTitle("Shuffle Cards", for: .normal)
            drawNewCardButton.setImage(nil, for: .normal)
            topWarningLabel.text = "There are no more cards left in the deck."
            endOfDeckShuffleButton.isHidden = false
        }
    }
    
    func enableNewDeckButton() {
        if DeckController.currentDeckID == "" {
            newDeckButton.isEnabled = true
        } else {
            newDeckButton.isEnabled = false
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
    
    func designMenuView() {
        pauseMenuView.layer.borderWidth = 2
        pauseMenuView.layer.cornerRadius = 12
        newDeckButton.layer.cornerRadius = 4
        shuffleDeckButton.layer.cornerRadius = 4
        cardLogButton.layer.cornerRadius = 4
        cancelMenuButton.layer.cornerRadius = 4
    }

}
