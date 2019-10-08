//
//  Card Controller.swift
//  Deck Of Cards
//
//  Created by Jordan Lamb on 10/3/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import UIKit

struct CardStringConstants {
    fileprivate static let baseURL = URL(string: "https://deckofcardsapi.com/api/deck")
    fileprivate static let newDeckComponent = "new/"
    fileprivate static let deckCountQueryKey = "deck_count"
    fileprivate static let shuffleComponent = "shuffle/"
}

class CardController {
    
    static func drawCard(numberOfCards: Int, with deckId: String,  completion: @escaping ((_ card: [Card]) -> Void)) {
        // Goal URL: https://deckofcardsapi.com/api/deck/<<deck_id>>/draw/?count=1
        guard var newCardURL = CardStringConstants.baseURL else {
            print("There was an error with the URL")
            completion([])
            return
        }
        newCardURL.appendPathComponent(deckId)
        newCardURL.appendPathComponent("draw/")
        guard var components = URLComponents(url: newCardURL, resolvingAgainstBaseURL: true) else { return }
        let cardCountQueryItem = URLQueryItem(name: "count", value: "\(numberOfCards)")
        components.queryItems = [cardCountQueryItem]
        guard let finalURL = components.url else { return }
        print("Draw \(numberOfCards) Card for Deck: \(deckId)")

        let dataTask = URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("Error decoding the Data: \(error.localizedDescription)")
            }
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
            do {
                let deck = try jsonDecoder.decode(Deck.self, from: data)
                completion(deck.cards)
            } catch {
                print("Error decoding card")
                return
            }
        }
        dataTask.resume()
    }
    
    static func getImage(forURL urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let finalURL = URL(string: urlString) else { return }
        let dataTask = URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("Error retriving the image: \(error.localizedDescription)")
            }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            completion(image)
        }
        dataTask.resume()
    }
    
}
