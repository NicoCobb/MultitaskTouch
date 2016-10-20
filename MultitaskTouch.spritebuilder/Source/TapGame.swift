//
//  TapGame.swift
//  MultitaskTouch
//
//  Created by nico cobb on 8/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class TapGame: CCNode {
    
    weak var tapTutorial: CCNode!
    
    var delegate: GameDelegate!
    var randomTileSpawn = arc4random_uniform(0)
    //continual 3 seconds w/ random 0 or 1 extra second = 2-4 seconds
    var TileSpawnBaseTime: CCTime = 3
    var blockTapTimeDecrease = 0
    var tutorialFinished = false
    
    func didLoadFromCCB() {
        //create game invisible and inactive
        opacity = 0
        cascadeOpacityEnabled = true
        userInteractionEnabled = false
        paused = true
        userInteractionEnabled = true
    }
    
    override func onEnter() {
        super.onEnter()
//        tapTutorial.positionInPoints = ccp(-contentSizeInPoints.width , contentSizeInPoints.height / 2)
//        var moveInAction = CCActionMoveTo(duration: 2.0, position: ccp(CGFloat(boundingBox().width / 2), CGFloat(boundingBox().height / 2)))
//        var moveInAnimated = CCActionEaseElasticOut(action: moveInAction, period: 2)
//        tapTutorial.runAction(moveInAnimated)
    }
    
    func startGeneratingTapBlocks() {
        randomTileSpawn = arc4random_uniform(2)
        let randomTileSpawnTime = CCTime(randomTileSpawn)
        scheduleOnce(#selector(TapGame.generateTapBlock), delay: randomTileSpawnTime)
    }
    
    func generateTapBlock() {
        //select enemy location
        
        let spawnedTile = CCBReader.load("TapTile") as! TapTile
        let tileXPosition = CGFloat(arc4random_uniform(UInt32(self.contentSizeInPoints.width)))
        let tileYPosition = CGFloat(arc4random_uniform(UInt32(self.contentSizeInPoints.height)))
        let tileSpawnPoint = ccp(tileXPosition, tileYPosition)
        spawnedTile.position = tileSpawnPoint
        spawnedTile.countTime -= blockTapTimeDecrease
        
        self.addChild(spawnedTile)
        
        //assign delegate
        spawnedTile.delegate = delegate
        //generate tiles between 2 and 4 seconds
//        var randomTileSpawnTime = CCTime(randomTileSpawn)
//        scheduleOnce("generateTapBlock", delay: randomTileSpawnTime)
    }
    
    func raiseDifficulty() {
        if TileSpawnBaseTime > 0 {
            TileSpawnBaseTime -= 1
            unschedule(#selector(TapGame.startGeneratingTapBlocks))
            schedule(#selector(TapGame.startGeneratingTapBlocks), interval: TileSpawnBaseTime)
        } else if blockTapTimeDecrease < 9 {
            blockTapTimeDecrease += 1
        }
    }
    
    func removeTutorial() {
        tapTutorial.removeFromParent()
    }
    
    func activateGame() {
//        var randomTileSpawnTime = CCTime(randomTileSpawn)
//        scheduleOnce("generateTapBlock", delay: randomTileSpawnTime)
        schedule(#selector(TapGame.startGeneratingTapBlocks), interval: TileSpawnBaseTime)
        generateTapBlock()
    }
    
    func showGame() {
        opacity = 1
        cascadeOpacityEnabled = true
        userInteractionEnabled = true
        paused = false
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if tutorialFinished == false {
            tutorialFinished = true
            let moveOutAction = CCActionMoveTo(duration: 1.0, position: ccp(CGFloat(-2 * boundingBox().width), CGFloat(boundingBox().height * 0.0)))
            let moveOutAnimated = CCActionEaseElasticIn(action: moveOutAction, period: 1)
            let deleteTutorial = CCActionCallFunc(target: self, selector: #selector(TapGame.removeTutorial))
            let runGame = CCActionCallFunc(target: self, selector: #selector(TapGame.activateGame))
            let sequence = CCActionSequence(array: [moveOutAnimated, deleteTutorial, runGame])
            tapTutorial.runAction(sequence)
            delegate.unpaused()
        }
    }
}