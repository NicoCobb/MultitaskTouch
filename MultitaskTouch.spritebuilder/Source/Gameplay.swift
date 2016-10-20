//
//  Gameplay.swift
//  MultitaskTouch
//
//  Created by nico cobb on 8/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

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
    
    weak var gameOne: DragGame!
    weak var gameTwo: SwipeGame!
    weak var gameThree: TapGame!
    weak var gameFour: TiltGame!
    
    weak var retryButton: CCButton!
    weak var menuButton: CCButton!
    weak var buttonNode: CCButton!
    weak var scoreLabel: CCLabelTTF!
    weak var highScoreLabel: CCLabelTTF!
    
    var raisingScore = false
    var swipeGameLoaded = false
    var tapGameLoaded = false
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        multipleTouchEnabled = true
        retryButton.userInteractionEnabled = false
        menuButton.userInteractionEnabled = false
        
        //add all games to specified locations
        gameOne = CCBReader.load("DragGame", owner: self) as! DragGame
        gameOneContainer.addChild(gameOne)
        gameOne.delegate = self
        gameOne.showGame()

        gameTwo = CCBReader.load("SwipeGame", owner: self) as! SwipeGame
        gameTwoContainer.addChild(gameTwo)
        gameTwo.opacity = 0
        gameTwo.cascadeOpacityEnabled = true
        gameTwo.userInteractionEnabled = false
        gameTwo.paused = true
        gameTwo.delegate = self

        gameThree = CCBReader.load("TapGame", owner: self) as! TapGame
        gameThreeContainer.addChild(gameThree)
        gameThree.opacity = 0
        gameThree.cascadeOpacityEnabled = true
        gameThree.userInteractionEnabled = false
        gameThree.paused = true
        gameThree.delegate = self
        
        gameFour = CCBReader.load("TiltGame", owner: self) as! TiltGame
        gameFourContainer.addChild(gameFour)
        gameFour.opacity = 0
        gameFour.cascadeOpacityEnabled = true
        gameFour.userInteractionEnabled = false
        gameFour.paused = true
        gameFour.delegate = self
    }
    
    override func onEnter() {
        super.onEnter()
    }

    func raiseScore() {
        ScoreSingleton.sharedInstance.score += 1
        scoreLabel.string = "\(ScoreSingleton.sharedInstance.score)"
        //load in mini games at intervals
        if ScoreSingleton.sharedInstance.score == 5 {
            gameThree.showGame()
            tapGameLoaded = true
            pauseGame()
        } else if ScoreSingleton.sharedInstance.score == 10 {
            gameTwo.showGame()
            swipeGameLoaded = true
            pauseGame()
        } else if ScoreSingleton.sharedInstance.score == 15 {
            gameFour.showGame()
//            gameFour.firstBlock.visible = true
            pauseGame()
        }
        if (ScoreSingleton.sharedInstance.score % 20) == 0 {
            gameOne.raiseDifficulty()
            gameTwo.raiseDifficulty()
            gameThree.raiseDifficulty()
            gameFour.raiseDifficulty()
        }
    }
    
    func menu() {
        let mainScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(mainScene)
    }
    
    func retry() {
        let gamePlayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gamePlayScene)
    }
}

extension Gameplay: GameDelegate{
    
    func gameOver() {
        gameOne.paused = true
        gameTwo.paused = true
        gameThree.paused = true
        gameFour.paused = true
        self.paused = true
        
        unschedule(#selector(Gameplay.raiseScore))
        //save high score
        if ScoreSingleton.sharedInstance.highScore < ScoreSingleton.sharedInstance.score {
            ScoreSingleton.sharedInstance.highScore = ScoreSingleton.sharedInstance.score
        }
        gameOne.unscheduleAllSelectors()
        gameOne.userInteractionEnabled = false
        gameTwo.unscheduleAllSelectors()
        gameTwo.userInteractionEnabled = false
        gameThree.unscheduleAllSelectors()
        gameThree.userInteractionEnabled = false
        gameFour.unscheduleAllSelectors()
        gameFour.userInteractionEnabled = false
        gameFour.motionKit.stopDeviceMotionUpdates()
//        gameFour.unschedule("generateTiltBlock")
        ScoreSingleton.sharedInstance.score = 0
        highScoreLabel.string = "High Score: \(ScoreSingleton.sharedInstance.highScore)"
        buttonNode.visible = true
        retryButton.userInteractionEnabled = true
        menuButton.userInteractionEnabled = true
    }
    
    func pauseGame() {
//        paused = true
        CCDirector.sharedDirector().pause()
        
        gameThree.unscheduleAllSelectors()
        gameTwo.unscheduleAllSelectors()
    }
    
    func unpaused() {
//        paused = false
        CCDirector.sharedDirector().resume()
        //resume swipe game
        if swipeGameLoaded == true {
            gameTwo.schedule("startGeneratingSwipeBlocks", interval: gameTwo.randomTileSpawnBaseTime)

        }
        //resume tap game
        if tapGameLoaded == true {
            gameThree.schedule("startGeneratingTapBlocks", interval: gameThree.TileSpawnBaseTime)

        }
        
        if raisingScore == false {
            schedule(#selector(Gameplay.raiseScore), interval: 1)
            raisingScore = true
        }
    }
    
}