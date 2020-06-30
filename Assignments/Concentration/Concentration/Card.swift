//
//  Card.swift
//  Concentration
//
//  Created by woong on 2020/06/23.
//  Copyright © 2020 woong. All rights reserved.
//

import Foundation

struct Card: Hashable {
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(identifire)
  }
  
  static func ==(lhs: Self, rhs: Self) -> Bool {
    return lhs.identifire == rhs.identifire
  }
  
  var isFaceUp = false
  var isMatched = false
  private var identifire: Int
  
  private static var identifireFactory = 0
  
  static func getUniqueIdentifire() -> Int {
    identifireFactory += 1
    return identifireFactory
  }
  
  init(identifire: Int) {
    self.identifire = identifire
  }
}
