//
//  Concentration.swift
//  Concentration
//
//  Created by woong on 2020/06/23.
//  Copyright © 2020 woong. All rights reserved.
//

import Foundation

class Concentration {
  private(set) var cards = [Card]()
  private var indexOfOneAndOnlyFaceUpCard: Int? {
    get {
      return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
    }
    set {
      for index in cards.indices {
        cards[index].isFaceUp = (index == newValue)
      }
    }
  }
  
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
        let randomIndex = cards.count.arc4random
        let card = cards.remove(at: randomIndex)
        newCards.append(card)
      }
    }
    cards = newCards
  }
  
  func chooseCard(at index: Int) {
    if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
      if cards[matchIndex] == cards[index] {
        cards[matchIndex].isMatched = true
        cards[index].isMatched = true
      }
      cards[index].isFaceUp = true
    } else {
      indexOfOneAndOnlyFaceUpCard = index
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

extension Collection {
  var oneAndOnly: Element? {
    return count == 1 ? first : nil
  }
}
