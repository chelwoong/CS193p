//
//  SetCardGame.swift
//  Assignment2_Set
//
//  Created by woong on 2020/07/17.
//  Copyright © 2020 woong. All rights reserved.
//

import Foundation

struct SetCardGame {
    var cards = [Card]()
    
    init() {
        for shapeCount in Card.ShapeCount.all {
            for color in Card.Color.all {
                for shape in Card.Shape.all {
                    for pattern in Card.Pattern.all {
                        let card = Card(color: color, shape: shape, shapeCount: shapeCount, pattern: pattern)
                        cards.append(card)
                    }
                }
            }
        }
        for _ in 0..<24 {
            if let card = cards.filter({ !$0.onGame }).randomElement(), let index = cards.firstIndex(of: card) {
                cards[index].onGame = true
            }
        }
        for _ in 0..<12 {
            if let card = cards.filter({ $0.onGame && !$0.isFaceUp }).randomElement(), let index = cards.firstIndex(of: card) {
                cards[index].isFaceUp = true
            }
        }
    }
}

extension Int {
  var arc4random: Int {
    if self > 0 {
      return Int(arc4random_uniform(UInt32(self)))
    } else if self < 0 {
      return -Int(arc4random_uniform(UInt32(abs(self))))
    } else {
      return 0
    }
  }
}
