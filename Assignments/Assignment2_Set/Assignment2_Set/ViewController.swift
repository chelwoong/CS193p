//
//  ViewController.swift
//  Assignment2_Set
//
//  Created by woong on 2020/07/16.
//  Copyright © 2020 woong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var setCardGame = SetCardGame()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(setCardGame.cards.filter({$0.onGame}).count)
        print(setCardGame.cards.filter({$0.isFaceUp}).count)
    }


}

