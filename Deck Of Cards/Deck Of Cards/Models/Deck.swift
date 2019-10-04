//
//  Deck.swift
//  Deck Of Cards
//
//  Created by Jordan Lamb on 10/4/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import Foundation

struct NewDeck: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case remaining
        case shuffled
        case deckid = "deck_id"
        
    }
    let remaining: Int
    let shuffled: Bool
    let deckid: String
}
