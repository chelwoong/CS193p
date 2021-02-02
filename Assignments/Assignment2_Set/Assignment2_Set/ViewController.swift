//
//  ViewController.swift
//  Assignment2_Set
//
//  Created by woong on 2020/07/16.
//  Copyright © 2020 woong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Views
    
    var setCardGame = SetCardGame()
    @IBOutlet var cardButtons: [CardButton]!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet var innerStackViews: [UIStackView]!
    
    @IBAction func touchCard(_ sender: CardButton) {
        guard let card = sender.card else { return }
        
        if let index = setCardGame.playingCards.firstIndex(of: card) {
            setCardGame.playingCards[index].isSelected.toggle()
        }
        updateViewsFromModel()
    }
    
    // MARK: - Methods
    
    func updateViewsFromModel() {
        for (index, card) in setCardGame.playingCards.enumerated() {
            print(index, card)
            cardButtons[index].card = card
            cardButtons[index].setNeedsDisplay()
        }
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        print(cardButtons.count)
        for idx in 0..<setCardGame.playingCards.count {
            cardButtons[idx].card = setCardGame.playingCards[idx]
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cardButtons.forEach {
            $0.superview?.setNeedsDisplay()
        }
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            guard let interfaceOrientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation else { return }

            if interfaceOrientation.isPortrait {
                print("portrait")
            } else {
                print("landscape")
            }
        })
    }
}

