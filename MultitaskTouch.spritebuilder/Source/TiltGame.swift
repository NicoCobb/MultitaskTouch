//
//  TiltGame.swift
//  MultitaskTouch
//
//  Created by nico cobb on 8/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class TiltGame: CCNode {
    
    var tiltHero: CCNode!
    var delegate: GameDelegate!
    let motionKit = MotionKit()
    
    var xValString: String!
    var yValString: String!
    var zValString: String!
    
    func didLoadFromCCB() {
        motionKit
    }
    
    func gameOver(){
        delegate.gameOver()
    }
}
