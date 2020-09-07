//
//  CardBehavior.swift
//  PlayingCard2
//
//  Created by Алексей Гребенкин on 04.09.2020.
//  Copyright © 2020 Alex Grebenkin. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.elasticity = 0.2
        behavior.resistance = 0.0001
        return behavior
    }()
    
    private func push(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        if let referenceBounds = dynamicAnimator?.referenceView?.bounds {
            let center = CGPoint(x: referenceBounds.midX, y: referenceBounds.midY)
            switch (item.center.x, item.center.y) {
            case let(x, y) where x < center.x && y < center.y:
                push.angle = CGFloat(arc4random_uniform(314)/100)
                case let(x, y) where x > center.x && y < center.y:
                    push.angle = CGFloat(314)/100 - CGFloat(arc4random_uniform(157)/100)
                case let(x, y) where x < center.x && y > center.y:
                push.angle = -CGFloat(arc4random_uniform(157)/100)
                case let(x, y) where x > center.x && y > center.y:
                push.angle = CGFloat(314)/100 + CGFloat(arc4random_uniform(157)/100)
            default:
                push.angle = CGFloat(arc4random_uniform(314)/100)
            }
        }
                
        push.magnitude = CGFloat(1.0) + CGFloat(arc4random_uniform(200)/100)
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}
