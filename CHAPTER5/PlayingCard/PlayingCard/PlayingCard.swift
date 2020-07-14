//
//  PlayingCards.swift
//  PlayingCard
//
//  Created by woong on 2020/07/14.
//  Copyright © 2020 woong. All rights reserved.
//

import Foundation

struct PlayingCard: CustomStringConvertible {
    
    var description: String { return "\(suit)\(rank)" }
    
    var suit: Suit
    var rank: Rank
    
    enum Suit: String, CustomStringConvertible {
        
        var description: String { return "\(self.rawValue)"}
        
        case spades = "♠️"
        case hearts = "❤️"
        case clubs = "♣️"
        case diamonds = "♦️"
        
        static var all: [Suit] = [Suit.spades, .hearts, .clubs, .diamonds]
    }
    
    enum Rank: CustomStringConvertible {
        var description: String { return "\(self.order)" }
        
        case ace
        case face(String)
        case numeric(Int)
        
        var order: Int {
            switch self {
            case .ace: return 1
            case .numeric(let pips): return pips
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            default: return 0
            }
        }
        
        static var all: [Rank] {
            var allRank = [Rank.ace]
            for pips in 2...10 {
                allRank.append(.numeric(pips))
            }
            allRank += [Rank.face("J"), .face("Q"), .face("K")]
            return allRank
        }
    }
}
