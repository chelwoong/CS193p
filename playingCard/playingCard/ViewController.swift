//
//  ViewController.swift
//  playingCard
//
//  Created by woong on 2018. 10. 19..
//  Copyright © 2018년 woong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var deck = PlayingCardDeck()
    
    @IBOutlet private var playingCardViews: [PlayingCardView]!
    
    @objc func nextCard(_ recognizer: UISwipeGestureRecognizer) {
        if let chosenCardView = recognizer.view as? PlayingCardView, let card = deck.draw() {
            chosenCardView.rank = card.rank.order
            chosenCardView.suit = card.suit.rawValue
        }
    }
    
    private var faceUpCardViews: [PlayingCardView] {
        return playingCardViews.filter {
                $0.isFaceUp &&
                !$0.isHidden &&
                $0.transform != CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0) &&
                $0.transform != CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        }
    }
    
    private var faceUpCardViewsMatch: Bool {
        return faceUpCardViews.count == 2 &&
            faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
            faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    
    lazy var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: view)
    
    lazy var cardBehavior: CardBehavior = CardBehavior(in: animator)
    
    private var lastChosenCardView: PlayingCardView?
    
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
            cardBehavior.addItem(cardView)
        }
    }
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
            case .ended:
                guard let chosenCardView = recognizer.view as? PlayingCardView, faceUpCardViews.count < 2 else { return }
                cardBehavior.removeItem(chosenCardView)
                lastChosenCardView = chosenCardView
                UIView.transition(
                    with: chosenCardView,
                    duration: 0.6,
                    options: [.transitionFlipFromLeft],
                    animations: {
                        chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                    }, completion: { finished in
                        // faceUpCardsViews가 애니메이션 되는 동안 다른 카드를 뒤집으면 거기에 포함되어서 이상하게 동작.
                        // 따라서 애니메이션 되는 카드는 faceUpCardsViews에 포함되지 않도록 수정하고 진행중인 카드는 지역변수로 잡아서 처리함
                        let cardsToAnimate = self.faceUpCardViews
                        // UIView.transition closure를 잡고있는 게 없으니 순환참조 x
                        if self.faceUpCardViewsMatch {
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.6,
                                delay: 0,
                                options: [],
                                animations: {
                                    cardsToAnimate.forEach { faceUpCardView in
                                        faceUpCardView.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                    }
                                },
                                completion: { position in
                                    UIViewPropertyAnimator.runningPropertyAnimator(
                                        withDuration: 0.75,
                                        delay: 0,
                                        options: [],
                                        animations: {
                                            cardsToAnimate.forEach {
                                                $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                $0.alpha = 0
                                            }
                                        },
                                        completion: { position in
                                            cardsToAnimate.forEach {
                                                $0.isHidden = true
                                                $0.alpha = 1
                                                $0.transform = .identity
                                            }
                                        }
                                    )
                                }
                            )
                        } else if cardsToAnimate.count == 2 {
                            // transform이 되는 동안 다른 transform이 개입하면 문제가 생김.
                            // 따라서 마지막에 선택된 transform이 animation을 제어하도록 추적해줘야함.
                            if chosenCardView == self.lastChosenCardView {
                                cardsToAnimate.forEach { faceUpCardView in
                                    UIView.transition(
                                        with: faceUpCardView,
                                        duration: 0.6,
                                        options: [.transitionFlipFromLeft],
                                        animations: {
                                            faceUpCardView.isFaceUp = false
                                        }, completion: { finished in
                                            self.cardBehavior.addItem(faceUpCardView)
                                        }
                                    )
                                }
                            }
                        } else {
                            if !chosenCardView.isFaceUp {
                                self.cardBehavior.addItem(chosenCardView)
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
            return CGFloat(arc4random_uniform(UInt32(self*10))/10)
        } else if self < 0 {
            return -CGFloat(arc4random_uniform(UInt32(abs(self*10))/10))
        } else {
            return 0
        }
    }
}
