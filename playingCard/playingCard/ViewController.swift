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
    
    private var faceUpCardViews: [PlayingCardView] {
        return playingCardViews.filter { $0.isFaceUp && !$0.isHidden }
    }
    
    private var faceUpCardViewsMatch: Bool {
        return faceUpCardViews.count == 2 &&
            faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
            faceUpCardViews[0].suit == faceUpCardViews[1].suit
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
                    }, completion: { finished in
                        // UIView.transition closure를 잡고있는 게 없으니 순환참조 x
                        if self.faceUpCardViewsMatch {
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.6,
                                delay: 0,
                                options: [],
                                animations: {
                                    self.faceUpCardViews.forEach { faceUpCardView in
                                        faceUpCardView.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                    }
                                },
                                completion: { position in
                                    UIViewPropertyAnimator.runningPropertyAnimator(
                                        withDuration: 0.75,
                                        delay: 0,
                                        options: [],
                                        animations: {
                                            self.faceUpCardViews.forEach {
                                                $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                $0.alpha = 0
                                            }
                                        },
                                        completion: { position in
                                            self.faceUpCardViews.forEach {
                                                $0.isHidden = true
                                                $0.alpha = 1
                                                $0.transform = .identity
                                            }
                                        }
                                    )
                                }
                            )
                        } else if self.faceUpCardViews.count == 2 {
                            self.faceUpCardViews.forEach { faceUpCardView in
                                UIView.transition(
                                    with: faceUpCardView,
                                    duration: 0.6,
                                    options: [.transitionFlipFromLeft],
                                    animations: {
                                        faceUpCardView.isFaceUp = false
                                    }
                                )
                            }
                        }
                    }
                )
            default:
                break
        }
    }
}

extension CGFloat {
    var arc4random: CGFloat {
        if self > 0 {
            return CGFloat(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -CGFloat(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
