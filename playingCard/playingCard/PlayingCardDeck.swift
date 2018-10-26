//
//  PlayingCardDeck.swift
//  playingCard
//
//  Created by woong on 2018. 10. 19..
//  Copyright © 2018년 woong. All rights reserved.
//

import Foundation

struct PlayingCardDeck {
    // 완전한 덱으로 시작할거기 때문에 내가 통제할 수 있도록 private(set)
    private(set) var cards = [PlayingCard]()
    
    init() {
        for suit in PlayingCard.Suit.all {
            for rank in PlayingCard.Rank.all {
                cards.append(PlayingCard(suit:suit, rank:rank))
            }
        }
    }
    
    mutating func draw() -> PlayingCard? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        } else {
            return nil
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
