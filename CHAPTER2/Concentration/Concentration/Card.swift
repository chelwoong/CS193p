//
//  Card.swift
//  Concentration
//
//  Created by woong on 2020/06/23.
//  Copyright © 2020 woong. All rights reserved.
//

import Foundation

struct Card {
  var isFaceUp = false
  var isMatched = false
  var identifire: Int
  
  static var identifireFactory = 0
  
  static func getUniqueIdentifire() -> Int {
    identifireFactory += 1
    return identifireFactory
  }
  
  init(identifire: Int) {
    self.identifire = Card.getUniqueIdentifire()
  }
}
