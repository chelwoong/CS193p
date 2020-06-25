//
//  Concentration.swift
//  Concentration
//
//  Created by woong on 2020/06/23.
//  Copyright © 2020 woong. All rights reserved.
//

import Foundation

class Concentration {
  
  var cards = [Card]()
  var indexOfOneAndOnlyFaceUpCard: Int?
  
  init(numberOfPairsOfCards: Int) {
    for _ in 0..<numberOfPairsOfCards {
      let card = Card(identifire: Card.getUniqueIdentifire())
      cards += [card, card]
    }
    
    // TODO: Suffle
    var newCards = [Card]()
    for _ in 0..<cards.count {
      if cards.count == 1 {
        let card = cards.remove(at: 0)
        newCards.append(card)
      } else {
        let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
        let card = cards.remove(at: randomIndex)
        newCards.append(card)
      }
    }
    cards = newCards
  }
  
  func chooseCard(at index: Int) {
    if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
      if cards[matchIndex].identifire == cards[index].identifire {
        cards[matchIndex].isMatched = true
        cards[index].isMatched = true
      }
      cards[index].isFaceUp = true
      indexOfOneAndOnlyFaceUpCard = nil
    } else {
      for downFlipIndex in cards.indices {
        cards[downFlipIndex].isFaceUp = false
      }
      cards[index].isFaceUp = true
      indexOfOneAndOnlyFaceUpCard = index
    }
  }
}
