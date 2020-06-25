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
  @IBOutlet private var cardButtons: [UIButton]!
  @IBOutlet private weak var flipCountLabel: UILabel!
  //var emojiChoices = ["🦇", "😱", "🙀", "👿", "🎃", "👻", "🍭", "🍬", "🍎"]
  private var flipCount = 0 {
    didSet {
      updateFlipCountLabel()
    }
  }
  private var emojiChoices = ["👿", "🎃", "👻", "🍭", "🍬", "🍎"]
  private var cardEmoji = [Int: String]()
  
  @IBAction private func touchCard(_ sender: UIButton) {
    if let cardIndex = cardButtons.firstIndex(of: sender) {
      flipCount += 1
      if cardEmoji[game.cards[cardIndex]] == nil, !emojiChoices.isEmpty {
        let emoji = emojiChoices.remove(at: emojiChoices.count.arc4random)
        cardEmoji[game.cards[cardIndex]] = emoji
      }
      game.chooseCard(at: cardIndex)
      updateViewFromModel()
    }
  }
  
  private func updateViewFromModel() {
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
  
  private func emoji(for card: Card) -> String {
    return cardEmoji[card] ?? "?"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
}

