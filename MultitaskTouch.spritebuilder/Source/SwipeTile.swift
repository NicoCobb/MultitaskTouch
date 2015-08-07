//
//  SwipeTile.swift
//  MultitaskTouch
//
//  Created by nico cobb on 8/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class SwipeTile: CCNode {
    
    var blockMoveSpeed = 4
    
    func didLoadFromCCB() {
        physicsBody.velocity = ccp(CGFloat(blockMoveSpeed), 0)
    }
}