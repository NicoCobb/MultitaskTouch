//
//  TapTile.swift
//  MultitaskTouch
//
//  Created by nico cobb on 8/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class TapTile: CCNode {
    
    weak var tapTimeLabel: CCLabelTTF!
    weak var tapBlock: CCNode!
    
    var tapTime: CCTime!
    var countTime: Int = 10 {
        didSet {
            tapTimeLabel.string = "\(countTime)"
            if countTime == 0 {
                //gameOver
            }
        }
    }
    
    func didLoadFromCCB() {
        tapTime = CCTime(10)
        shrinkBlock()
        userInteractionEnabled = true
        rotation = 45
        schedule("countDown", interval: 1)
    }
    
    func shrinkBlock() {
        var shrink = CCActionScaleTo(duration: tapTime, scale: 0)
        //var nextAction = CCAction()
        //runAction(CCActionSequence(array:[shrink, nextAction])
        runAction(shrink)
    }
    
    func countDown() {
        countTime--
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        self.removeFromParent()
        println("detected touch")
    }
}