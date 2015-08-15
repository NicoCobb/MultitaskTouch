//
//  CubeRunnerObstacle.swift
//  MultitaskTouch
//
//  Created by nico cobb on 8/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class TiltTile: CCSprite {
    
    var tileSpeed: CGFloat = 1
//    var delegate: GameDelegate!
    
    func didLoadFromCCB() {
        schedule("updateBox", interval: 1.0/60.0)
    }
    
    func updateBox(){
        positionInPoints.y -= tileSpeed
        
        if positionInPoints.y < -10 {
            removeFromParent()
        }
    }
}