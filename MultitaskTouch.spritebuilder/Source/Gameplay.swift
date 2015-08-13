//
//  Gameplay.swift
//  MultitaskTouch
//
//  Created by nico cobb on 8/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

////global variables for the 4 different game overs
//var swipeGameOver = false {
//    didSet {
//        Gameplay.gameOver()
//    }
//}
//
//var tapGameOver = false {
//    didSet{
//        
//    }
//}
//
//var tiltGameOver = false {
//    didSet{
//        
//    }
//}
//
//var dragGameOver = false {
//    didSet{
//        
//    }
//}

var currentGame: Gameplay?

class Gameplay: CCScene {
    
    //drag
    weak var gameOneContainer: CCNode!
    //swipe
    weak var gameTwoContainer: CCNode!
    //tap
    weak var gameThreeContainer: CCNode!
    //tilt
    weak var gameFourContainer: CCNode!
    
    weak var retryButton: CCButton!
    weak var menuButton: CCButton!
    weak var buttonNode: CCButton!
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        multipleTouchEnabled = true
        retryButton.userInteractionEnabled = false
        menuButton.userInteractionEnabled = false
        
        
        //add all games to specified locations
//        var gameOne = CCBReader.load("DragGame", owner: self)
//        gameOneContainer.addChild(gameOne)
//
//        var gameTwo = CCBReader.load("SwipeGame", owner: self)
//        gameTwoContainer.addChild(gameTwo)
//
//        var gameThree = CCBReader.load("TapGame", owner: self) as! TapGame
//        gameThreeContainer.addChild(gameThree)
//        gameThree.delegate = self
//        
//        var gameFour = CCBReader.load("TiltGame", owner: self)
//        gameFourContainer.addChild(gameFour)
    }

}

extension Gameplay: GameDelegate{
    
    func gameOver() {
        self.paused = true
        buttonNode.visible = true
    }
    
}