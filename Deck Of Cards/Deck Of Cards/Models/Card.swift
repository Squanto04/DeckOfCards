//
//  Card.swift
//  Deck Of Cards
//
//  Created by Jordan Lamb on 10/3/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import Foundation

struct Deck: Decodable {
    private enum CodingKeys: String, CodingKey {
        case remaining
        case deckid = "deck_id"
        case cards
    }
    let remaining: Int
    let deckid: String
    let cards: [Card]
}

struct Card: Decodable {
    let value: String
    let suit: String
    let image: String
    let code: String
}
