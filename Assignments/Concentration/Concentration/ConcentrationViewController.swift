//
//  ViewController.swift
//  Concentration
//
//  Created by woong on 2020/06/23.
//  Copyright © 2020 woong. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    // MARK: - Constants
    
    enum Theme: String, CaseIterable {
        case halloween
        case sports
        case country
        case face
        case animal
        case fruit
        
        var emojiChoices: [String] {
            switch self {
                case .halloween: return ["🦇", "😱", "🙀", "👿", "🎃", "👻", "🍭", "🍬"]
                case .sports: return ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉"]
                case .country: return ["🇰🇷", "🇱🇷", "🇩🇰", "🇱🇾", "🇷🇼", "🇱🇺", "🇱🇮", "🇰🇵"]
                case .face: return ["😀", "😎", "🙃", "😭", "😤", "😡", "😰", "😍"]
                case .animal: return ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼"]
                case .fruit: return ["🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓"]
            }
        }
        
        var tintColor: UIColor {
            switch self {
                case .halloween: return .orange
                case .sports: return #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
                case .country: return #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1)
                case .face: return #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
                case .animal: return #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
                case .fruit: return #colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1)
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
                case .halloween: return .black
                case .sports: return #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
                case .country: return #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
                case .face: return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                case .animal: return #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
                case .fruit: return #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)
            }
        }
    }
    
    // MARK: - Properties
    
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count+1)/2)
    var currentTheme: Theme = .halloween {
        didSet {
            view.backgroundColor = currentTheme.backgroundColor
            emojiChoices = currentTheme.emojiChoices
            updateViewFromModel()
        }
    }
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    @IBOutlet weak var scoreLabel: UILabel! {
        didSet {
            updateScoreLabel()
        }
    }
    
    private lazy var emojiChoices = currentTheme.emojiChoices
    private var cardEmoji = [Card:String]()
    
    // MARK: - Methods
    
    private func updateViewFromModel() {
        guard cardButtons != nil else { return }
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = .white
            } else {
                button.setTitle(" ", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : currentTheme.tintColor
            }
        }
        updateFlipCountLabel()
        updateScoreLabel()
    }
    
    private func updateFlipCountLabel() {
        //    let attributes: [NSAttributedString.Key:Any] = [
        //      .strokeWidth : 5.0,
        //      .strokeColor : currentTheme.tintColor
        //    ]
        //    let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        //    flipCountLabel.attributedText = attributedString
        flipCountLabel.text = "Flips: \(game.flipCount)"
    }
    
    private func updateScoreLabel() {
        scoreLabel.text = "Score: \(game.score)"
    }
    
    @IBAction func touchNewGame(_ sender: UIButton) {
        if let randomTheme = Theme.allCases.randomElement() {
            game = Concentration(numberOfPairsOfCards: (cardButtons.count+1)/2)
            currentTheme = randomTheme
        }
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardIndex = cardButtons.firstIndex(of: sender) {
            if cardEmoji[game.cards[cardIndex]] == nil, !emojiChoices.isEmpty {
                let emojiIndex = emojiChoices.remove(at: emojiChoices.count.arc4random)
                cardEmoji[game.cards[cardIndex]] = emojiIndex
            }
            game.chooseCard(at: cardIndex)
            updateViewFromModel()
        }
    }
    
    private func emoji(for card: Card) -> String {
        return cardEmoji[card] ?? "?"
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

