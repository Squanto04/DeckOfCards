//
//  Deck Controller.swift
//  Deck Of Cards
//
//  Created by Jordan Lamb on 10/4/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import Foundation

struct DeckStringConstants {
    fileprivate static let baseURL = URL(string: "https://deckofcardsapi.com/api/deck")
    fileprivate static let newDeckComponent = "new/"
    fileprivate static let shuffleComponent = "shuffle/"
    fileprivate static let deckCountQueryKey = "deck_count"
}

class DeckController {
    
    static var currentDeckID = ""
    
    static func newDeckWith(count: Int, completion: @escaping (_ deck: NewDeck) -> Void) {
        // Goal URL: https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1
        guard var newDeckurl = DeckStringConstants.baseURL else { return }
        newDeckurl.appendPathComponent(DeckStringConstants.newDeckComponent)
        newDeckurl.appendPathComponent(DeckStringConstants.shuffleComponent)
        guard var components = URLComponents(url: newDeckurl, resolvingAgainstBaseURL: true) else { return }
        let deckCountQuery = URLQueryItem(name: DeckStringConstants.deckCountQueryKey, value: "\(count)")
        components.queryItems = [deckCountQuery]
        guard let finalDeckURL = components.url else { return }
        print(finalDeckURL)
        
        let dataTask = URLSession.shared.dataTask(with: finalDeckURL) { (data, _, error) in
            if let error = error {
                print("There was an error decoding new deck: \(error.localizedDescription)")
            }
            guard let data = data else { return }
            do {
                let deck = try JSONDecoder().decode(NewDeck.self, from: data)
                self.currentDeckID = deck.deckid
                completion(deck)
            } catch {
                print("There was an error decoding to deck object: \(error.localizedDescription)")
            }
        }
        dataTask.resume()
    }
    
    static func shuffleCards(deckId: String, completion: @escaping () -> Void) {
        // Goal URL: https://deckofcardsapi.com/api/deck/<<deck_id>>/shuffle/
        guard var shuffleURL = DeckStringConstants.baseURL else {
            print("There was an error with the URL")
            return
        }
        shuffleURL.appendPathComponent(deckId)
        shuffleURL.appendPathComponent(DeckStringConstants.shuffleComponent)
        print(shuffleURL)
        let dataTask = URLSession.shared.dataTask(with: shuffleURL)
        dataTask.resume()
    }
    
}
