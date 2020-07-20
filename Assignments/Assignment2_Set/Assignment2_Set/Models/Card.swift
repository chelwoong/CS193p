//
//  Card.swift
//  Assignment2_Set
//
//  Created by woong on 2020/07/17.
//  Copyright © 2020 woong. All rights reserved.
//

import UIKit

struct Card: Hashable {
    var color: Color
    var shape: Shape
    var shapeCount: ShapeCount
    var pattern: Pattern
    var isFaceUp = false
    var isSelected = false
    var isMatched = false
    var onGame = false
    
    enum ShapeCount: Int {
        case one = 1
        case two = 2
        case three = 3
        
        static var all: [ShapeCount] = [.one, .two, .three]
    }
    
    enum Shape {
        case circle
        case triangle
        case rectangle
        
        static var all: [Shape] = [.circle, .rectangle, .triangle]
    }
    
    enum Color {
        case red
        case blue
        case green
        
        static var all: [Color] = [.red, .blue, .green]
    }
    
    enum Pattern {
        case shadow
        case fill
        case empty
        
        static var all: [Pattern] = [.shadow, .empty, .fill]
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.color == rhs.color &&
            lhs.shape == rhs.shape &&
            lhs.shapeCount  == rhs.shapeCount &&
            lhs.pattern == rhs.pattern
    }
}
