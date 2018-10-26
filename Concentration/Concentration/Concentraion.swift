//
//  Concentraion.swift
//  Concentration
//
//  Created by woong on 2018. 10. 16..
//  Copyright © 2018년 woong. All rights reserved.
//

// Model
import Foundation

class Concentration {
    // class를 만들고 나면 이것의 공개 API가 무엇일지 생각해야 한다.
    
    // ()는 init의 한 방법. 빈 배열을 만들어주는 것.
//    var cards = Array<Card>()
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            // extension Collection protocol
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly

            // MARK: - Closure refactoring 다시보기
//            // what!?!@!@#?!@?#@!?#!@#?? ㅜㅜㅜㅜ 어려워 나중에 다시..
//            let faceUpCardIndices = cards.indices.filter { cards[$0].isFaceUp }
//            return faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil
//            var foundIndex: Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    } else {
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
            
        }
    }
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chsoen index not in the cards")
        // match되지 않은 경우부터 처리
        // 1. 모두 뒷면 2. 모두 앞면 3. 하나만 앞면
        if !cards[index].isMatched {
            // matchIndex != index, 내가 이미 선택한 카드가 아닌지 확인
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
//                indexOfOneAndOnlyFaceUpCard 의 get set을 설정해줌으로써 생략가능
//                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                // either no cards or 2 cards are face up
//                indexOfOneAndOnlyFaceUpCard 의 get set을 설정해줌으로써 생략가능
//                for flipDownIndex in cards.indices {
//                    cards[flipDownIndex].isFaceUp = false
//                }
//                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
                
            }
        }
        
    }
    
    // 카드의 개수는 고정이 아니니까 자체적인 init을 만들어야 한다.
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            
            // 구조체는 참조할 때 복사하기 때문에 다른걸 만들필요 없이 그냥 카드를 두 번 넣으면 된다.
            // 둘이 같은지 아닌지 확인하면 되는데, 다른 값이 들어올 때 새로운 카드를 만들게되기 때문에 이렇게 한다.
            cards += [card, card]
//            cards.append(card)
//            cards.append(card)
        }
        
        // TODO: Shuffle of Cards
        cards.shuffle()
        
    }
}

// MARK: extension Collection protocol 다시보기
extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
