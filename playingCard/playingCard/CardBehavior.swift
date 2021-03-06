//
//  CardBehavior.swift
//  playingCard
//
//  Created by woong on 2021/02/07.
//  Copyright © 2021 woong. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    
    lazy private(set) var collistionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    lazy private(set) var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        // 1.0 = 가속도 x, 1.1 부딫힐수록 점점 빨라짐, 0.9 점점 느려짐
        behavior.elasticity = 1.0
        behavior.resistance = 0
        return behavior
    }()
    
    private func push(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        if let referenceBounds = dynamicAnimator?.referenceView?.bounds {
            let center = CGPoint(x: referenceBounds.minX, y: referenceBounds.midY)
            switch (item.center.x, item.center.y) {
                // 1사분면
                case let (x, y) where x < center.x && y < center.y:
                    push.angle = (CGFloat.pi/2).arc4random
                // 2사분면
                case let (x, y) where x > center.x && y < center.y:
                    push.angle = CGFloat.pi - (CGFloat.pi/2).arc4random
                // 3사분면
                case let (x, y) where x < center.x && y > center.y:
                    push.angle = (-CGFloat.pi/2).arc4random
                // 4사분면
                case let (x, y) where x > center.x && y > center.y:
                    push.angle = CGFloat.pi + (CGFloat.pi/2).arc4random
                default:
                    push.angle = (2*CGFloat.pi).arc4random
            }
        }
        push.magnitude = CGFloat(1.0) + CGFloat(2.0).arc4random
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    func addItem(_ item: UIDynamicItem) {
        collistionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        collistionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    override init() {
        super.init()
        addChildBehavior(collistionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}
