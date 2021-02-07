//
//  ViewController.swift
//  playingCard
//
//  Created by woong on 2018. 10. 19..
//  Copyright © 2018년 woong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var deck = PlayingCardDeck()
    
    @IBOutlet var playingCardViews: [PlayingCardView]!
    
    @objc func nextCard(_ recognizer: UISwipeGestureRecognizer) {
        if let chosenCardView = recognizer.view as? PlayingCardView, let card = deck.draw() {
            chosenCardView.rank = card.rank.order
            chosenCardView.suit = card.suit.rawValue
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        var cards = [PlayingCard]()
        for _ in 1...((playingCardViews.count+1)/2) {
            let card = deck.draw()!
            cards += [card, card]
        }
        for cardView in playingCardViews {
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            let tap = UITapGestureRecognizer(target: self, action: #selector(flipCard(_:)))
            cardView.addGestureRecognizer(tap)
        }
    }

    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            guard let chosenCardView = recognizer.view as? PlayingCardView else { return }
            UIView.transition(
                with: chosenCardView,
                duration: 0.6,
                options: [.transitionFlipFromLeft],
                animations: {
                    chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                }
            )
        default:
            break
        }
    }
}

