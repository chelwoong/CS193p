//
//  Card.swift
//  Concentration
//
//  Created by woong on 2018. 10. 16..
//  Copyright © 2018년 woong. All rights reserved.
//

import Foundation

// 이모티콘이나 이미지 같은 UI관련한 것들은 Model에 들어있으면 안된다!!!
// Model은 어떻게 동작하는지에 관한 곳이지 어떻게 보여지는 곳에 관한 부분이 아니다! UI와 독립적!
struct Card: Hashable {
    
    var hashValue: Int { return identifier }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    
    
    private static var identiferFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
//        Card.identiferFactory += 1
//        return Card.identiferFactory
        // static 메서드 안에서는 생략가능!
        identiferFactory += 1
        return identiferFactory
    }
    
    // 저대로 두면 identifier를 초기화 시켜주지 않아서 에러가 발생! 초기화 해주자!
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
}
