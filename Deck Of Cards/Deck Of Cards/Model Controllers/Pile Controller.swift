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
    fileprivate static let countQueryTerm = "count"
    fileprivate static let drawTerm = "draw/"
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
        
        let dataTask = URLSession.shared.dataTask(with: finalAddToPileURL)
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
    
    static func addCardsBackToDeck(for deck: String, pile amount: Int, completion: @escaping () -> Void) {
        // Goal URL: https://deckofcardsapi.com/api/deck/<<deck_id>>/pile/discarded/draw/?count=2
        guard var backToDeckURL = PileStringConstants.baseURL else { return }
        backToDeckURL.appendPathComponent(deck)
        backToDeckURL.appendPathComponent(PileStringConstants.pileTerm)
        backToDeckURL.appendPathComponent(PileStringConstants.pileName)
        backToDeckURL.appendPathComponent(PileStringConstants.drawTerm)
        guard var components = URLComponents(url: backToDeckURL, resolvingAgainstBaseURL: true) else { return }
        let countQuery = URLQueryItem(name: PileStringConstants.countQueryTerm, value: "\(amount)")
        components.queryItems = [countQuery]
        guard let returnPileURL = components.url else { return }
        print(returnPileURL)
        let dataTask = URLSession.shared.dataTask(with: returnPileURL)
        dataTask.resume()
    }
    
}
