//
//  ViewController.swift
//  Concentration
//
//  Created by woong on 2018. 10. 16..
//  Copyright © 2018년 woong. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    // Concentraion안의 요소가 모두 초기화 가능할 때 사용 가능.
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    // 처음 변수를 초기화 할 때는 didSet을 하지 않는다.
    // 그래서 string에 attributes를 줘도 처음엔 적용되지 않는다.
    private(set) var flipCount = 0 {
        // 모든 속성은 원한다면 didSet이 설정 가능하다.
        // 속성이 설정될때마다 실행!
        didSet {
//            flipCountLabel.text = "Flips: \(flipCount)"
            
//            let attributes: [NSAttributedString.Key : Any] = [
//                .strokeWidth: 5.0,
//                .strokeColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
//            ]
//            let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
//            flipCountLabel.attributedText = attributedString
            
            // 처음에는 적용되지 않으니 따로 함수로 빼고 @IBOutlet의 flipCountLabel에 didSet에도 설정
            updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key : Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    

    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            print("cardButtons index: \(cardNumber)")
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    private  func updateViewFromModel() {
        if cardButtons != nil {
            // MVC가 준비되기 전에 cardButtons가 nil이다. MVC가 준비되기 전에 호출되지 않도록 조심해야한다!
            for index in cardButtons.indices {
                print("index: \(index)")
                let button = cardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: UIControl.State.normal)
                    button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                } else {
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                }
            }
        }
    }
    
    var theme: String? {
        didSet {
            emojiChoices = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }
    
//    private var emojiChoices = ["🎉","🎃","😱","👻","🍭","🍬","🦇","😈"]
    private var emojiChoices = "🎉🎃😱👻🍭🍬🦇😈"

    private var emoji = [Card : String]()
    
    private func emoji(for card: Card) -> String{
        if emoji[card] == nil, emojiChoices.count > 0 {
            // Int를 확장시켜서 무작위 정수를 줄 수 있다면 이 부분을 깔끔하게 처리할 수 있다.
//            emoji[card] = emojiChoices.remove(at: emojiChoices.count.arc4random)
            // 문자열과 배열 모두 Range Replaceable Collectiond 이지만,
            // emojiChoices를 문자열로 바꾸면 Int로 색인할 수 없기 때문에 에러가 발생한다.
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
            
            
        }
        
        return emoji[card] ?? "?"
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

