//
//  PlayingCard.swift
//  playingCard
//
//  Created by woong on 2018. 10. 19..
//  Copyright © 2018년 woong. All rights reserved.
//

import Foundation

struct PlayingCard: CustomStringConvertible {
    var description: String { return "\(rank)\(suit)"}
    
    // 카드에 필요한건 숫자랑 모양뿐!
    var suit: Suit
    var rank: Rank
    
    enum Suit: String, CustomStringConvertible {
        case spades = "♠️"
        case hearts = "❤️"
        case dimonds = "♣️"
        case clubs = "♦️"
        
        static var all = [Suit.spades, .hearts, .clubs, .dimonds]
        
        var description: String {
            return rawValue
        }
    }
    
    enum Rank: CustomStringConvertible {
        case ace
        case face(String)
        case numeric(Int)

        
        var order: Int {
            switch self{
            case .ace: return 1
            case .numeric(let pips): return pips
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            default: return 0
            }
        }
        
        static var all: [Rank] {
            var allRanks = [Rank.ace]
            for pips in 2...10 {
                allRanks.append(Rank.numeric(pips))
            }
            allRanks += [Rank.face("J"),.face("Q"),.face("K")]
            return allRanks
        }
        
        var description: String {
            switch self {
            case .ace: return "A"
            case .numeric(let pips): return String(pips)
            case .face(let kind): return kind
            }
        }
        
    }
}
