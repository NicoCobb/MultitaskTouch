//
//  SwipeTile.swift
//  MultitaskTouch
//
//  Created by nico cobb on 8/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

enum blockDirectionType {
    case Up, Down, Left, Right
}

class SwipeTile: CCSprite {
    
    var blockMoveSpeed = 1.0
    var blockDirection: blockDirectionType = .Up {
        didSet {
            if blockDirection == .Up {
                rotation = 0
            } else if blockDirection == .Down {
                rotation = 180
            } else if blockDirection == .Right {
                rotation = 90
            } else {
                rotation = 270
            }
        }
    }
    
    func didLoadFromCCB() {
        var randomBlockDirection = arc4random_uniform(4)
        if randomBlockDirection == 0 {
            blockDirection = .Up
        } else if randomBlockDirection == 1 {
            blockDirection = .Down
        } else if randomBlockDirection == 2 {
            blockDirection = .Left
        } else {
            blockDirection = .Right
        }
    }
    
    override func update(delta: CCTime) {
        self.position.x += CGFloat(blockMoveSpeed)
    }
}