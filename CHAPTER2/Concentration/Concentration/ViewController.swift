//
//  ViewController.swift
//  Concentration
//
//  Created by woong on 2020/06/23.
//  Copyright © 2020 woong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count+1)/2)
  @IBOutlet var cardButtons: [UIButton]!
  
  @IBOutlet weak var flipCountLabel: UILabel!
  //var emojiChoices = ["🦇", "😱", "🙀", "👿", "🎃", "👻", "🍭", "🍬", "🍎"]
  var flipCount = 0 {
    didSet {
      flipCountLabel.text = "Flip Count: \(flipCount)"
    }
  }
  var emojiChoices = ["👿", "🎃", "👻", "🍭", "🍬", "🍎"]
  var cardEmoji = [Int: String]()
  
  @IBAction func touchCard(_ sender: UIButton) {
    if let cardIndex = cardButtons.firstIndex(of: sender) {
      flipCount += 1
      if cardEmoji[game.cards[cardIndex].identifire] == nil {
        if emojiChoices.count == 1 {
          let emoji = emojiChoices.remove(at: 0)
          cardEmoji[game.cards[cardIndex].identifire] = emoji
        } else {
          let emoji = emojiChoices.remove(at: Int(arc4random_uniform(UInt32(emojiChoices.count))))
          cardEmoji[game.cards[cardIndex].identifire] = emoji
        }
        
      }
      game.chooseCard(at: cardIndex)
      updateViewFromModel()
    }
  }
  
  func updateViewFromModel() {
    for index in cardButtons.indices {
      let button = cardButtons[index]
      let card = game.cards[index]
      if card.isFaceUp {
        button.setTitle(emoji(for: card), for: .normal)
        button.backgroundColor = .white
      } else {
        button.setTitle(" ", for: .normal)
        button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.9535570741, green: 0.5023825169, blue: 0.2160084248, alpha: 1)
      }
    }
  }
  
  func emoji(for card: Card) -> String {
    return cardEmoji[card.identifire] ?? "?"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }


}

