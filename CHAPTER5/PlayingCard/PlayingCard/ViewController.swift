//
//  ViewController.swift
//  PlayingCard
//
//  Created by woong on 2020/07/14.
//  Copyright © 2020 woong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var deck = PlayingCardDeck()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0...10 {
            if let card = deck.draw() {
                print(card.description)
            }
        }
    }


}

