//
//  Stats.swift
//  MultitaskTouch
//
//  Created by nico cobb on 8/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Stats: CCScene {
    weak var menuButton: CCButton!
    
    func menu() {
        let mainScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(mainScene)
    }
}