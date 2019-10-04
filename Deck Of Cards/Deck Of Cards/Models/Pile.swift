//
//  Pile.swift
//  Deck Of Cards
//
//  Created by Jordan Lamb on 10/4/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import Foundation

struct PileTLD: Decodable {
    let piles: Pile
    let remaining: Int
    let success: Bool
}

struct Pile: Decodable {
    let discarded: Discarded
}

struct Discarded: Decodable {
    let cards: [Card]
    let remaining: Int
}
