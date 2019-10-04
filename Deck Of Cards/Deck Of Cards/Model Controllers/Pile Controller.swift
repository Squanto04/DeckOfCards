//
//  Pile Controller.swift
//  Deck Of Cards
//
//  Created by Jordan Lamb on 10/4/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import Foundation

struct PileStringConstants {
    fileprivate static let baseURL = URL(string: "https://deckofcardsapi.com/api/deck")
    fileprivate static let pileTerm = "pile"
    fileprivate static let addTerm = "add/"
    fileprivate static let cardTerm = "cards"
    fileprivate static let pileName = "discarded"
    fileprivate static let listTerm = "list/"
}

class PileController {
    
    static var leftInDeck = 52
    static var leftInPile = 0
    
    static func addCardToPile(deck: String, card: Card, completion: @escaping () -> Void) {
        // Goal URL: https://deckofcardsapi.com/api/deck/ufl28o8bm2wi/pile/discarded/add/?cards=4S
        guard var addToPileURL = PileStringConstants.baseURL else { return }
        addToPileURL.appendPathComponent(deck)
        addToPileURL.appendPathComponent(PileStringConstants.pileTerm)
        addToPileURL.appendPathComponent(PileStringConstants.pileName)
        addToPileURL.appendPathComponent(PileStringConstants.addTerm)
        guard var components = URLComponents(url: addToPileURL, resolvingAgainstBaseURL: true) else { return }
        let cardQuery = URLQueryItem(name: PileStringConstants.cardTerm, value: card.code)
        components.queryItems = [cardQuery]
        guard let finalAddToPileURL = components.url else { return }
        print(finalAddToPileURL)
        
        let dataTask = URLSession.shared.dataTask(with: finalAddToPileURL) { (data, _, error) in
            if let error = error {
                print("AddCardToPile Decoding Error: \(error.localizedDescription)")
            }
            guard let data = data else {
                print("There is no pile data")
                return }
            do {
                let pile = try JSONDecoder().decode(PileTLD.self, from: data)
                print(pile.success)
                print("\(pile.remaining) left in the deck")
                print("\(pile.piles.discarded.remaining) Cards in Pile")
                completion()
            } catch {
                print("AddCardToPile Decoding To pile Error: \(error.localizedDescription)")
            }
        }
        dataTask.resume()
    }
    
    static func listCardsInPile(deck: String, completion: @escaping (_ card: [Card]) -> Void) {
        guard var cardsInPileURL = PileStringConstants.baseURL else { return }
        cardsInPileURL.appendPathComponent(deck)
        cardsInPileURL.appendPathComponent(PileStringConstants.pileTerm)
        cardsInPileURL.appendPathComponent(PileStringConstants.pileName)
        cardsInPileURL.appendPathComponent(PileStringConstants.listTerm)
        print(cardsInPileURL)
        
        let dataTask = URLSession.shared.dataTask(with: cardsInPileURL) { (data, _, error) in
            if let error = error {
                print("CardsInPile Error: \(error.localizedDescription)")
            }
            guard let data = data else { return }
            do {
                let pileTLD = try JSONDecoder().decode(PileTLD.self, from: data)
                self.leftInDeck = pileTLD.remaining
                self.leftInPile = pileTLD.piles.discarded.remaining
                completion(pileTLD.piles.discarded.cards)
            } catch {
                print("CardsInPile Decoding To cardsInPile Error: \(error.localizedDescription)")
            }
        }
        dataTask.resume()
    }
    
    static func addCardsBackToDeck(pile amount: Int, completion: @escaping () -> Void) {
        // Goal URL: https://deckofcardsapi.com/api/deck/<<deck_id>>/pile/discarded/draw/?count=2
        guard var backToDeckURL = PileStringConstants.baseURL else { return }
    }
    
}
