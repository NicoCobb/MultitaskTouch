//
//  TiltGame.swift
//  MultitaskTouch
//
//  Created by nico cobb on 8/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import CoreMotion

class TiltGame: CCNode, CCPhysicsCollisionDelegate {
    
    weak var tiltHero: CCNode!
    weak var gamePhysicsNode: CCPhysicsNode!
    
    weak var tiltTutorial: CCNode!
    
    var delegate: GameDelegate!
    //generate tiles between 3 and 5 seconds
    var randomTiltSpawnBaseTime: CCTime = 4
    let motionKit = MotionKit()
    var blocksInSpawn = 7
    var tutorialFinished = false
    
    var xValString: String!
    var yValString: String!
    var zValString: String!
    
    func didLoadFromCCB() {
        //create game invisible and inactive
        opacity = 0
        cascadeOpacityEnabled = true
        userInteractionEnabled = false
        paused = true
        gamePhysicsNode.collisionDelegate = self
//        gamePhysicsNode.debugDraw = true
    }
    
    override func onEnter() {
        super.onEnter()
    }
    
    func reposition (x: Double) {
        gamePhysicsNode.positionInPoints.x = CGFloat(gamePhysicsNode.positionInPoints.x + CGFloat(-x*2))
        tiltHero.positionInPoints.x = CGFloat(tiltHero.positionInPoints.x + CGFloat(x*2))
        tiltHero.rotation  = Float(x * 45)

    }
    
    func generateTiltBlock() {
        //select block location
//        self.unschedule("generateTiltBlock")
        for blockCount in 0..<blocksInSpawn {
            var blockSpacing = CGFloat(3) * contentSizeInPoints.width / CGFloat(blocksInSpawn)
            var tileXPositionShift = CGFloat(arc4random_uniform(UInt32(blockSpacing)) + UInt32(blockSpacing * CGFloat(blockCount))) - 1 * contentSizeInPoints.width
            var tileYPositionShift = CGFloat(arc4random_uniform(200))
            var tileSpawnPoint = ccp(tiltHero.positionInPoints.x - ((1/2) * contentSizeInPoints.width)  + tileXPositionShift, (contentSizeInPoints.height + 10 + tileYPositionShift))
            var spawnedTile = CCBReader.load("TiltTile") as! TiltTile
            spawnedTile.position = tileSpawnPoint
            gamePhysicsNode.addChild(spawnedTile)
        }
    }
    
    func startGeneratingTiltBlocks() {
        var randomTileSpawn = arc4random_uniform(2)
        var randomTileSpawnTime = CCTime(randomTileSpawn)
        scheduleOnce("generateTiltBlock", delay: randomTileSpawnTime)
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, tiltHero: CCNode!, tiltTile: CCNode!) -> Bool {
        gameOver()
        return true
    }
    
    func gameOver(){
        self.paused = true
        delegate.gameOver()
    }
    
    func raiseDifficulty() {
        blocksInSpawn++
    }
    
    func removeTutorial() {
        tiltTutorial.removeFromParent()
    }
    
    func activateGame() {
        motionKit.getAccelerometerValues(interval: (1.0/60)){
            (x, y, z) in
            self.reposition(y)
        }
        schedule("startGeneratingTiltBlocks", interval: randomTiltSpawnBaseTime)
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
            var moveOutAction = CCActionMoveTo(duration: 1.0, position: ccp(CGFloat(2 * boundingBox().width), CGFloat(boundingBox().height / 2)))
            var moveOutAnimated = CCActionEaseElasticIn(action: moveOutAction, period: 1)
            var deleteTutorial = CCActionCallFunc(target: self, selector: "removeTutorial")
            var runGame = CCActionCallFunc(target: self, selector: "activateGame")
            var sequence = CCActionSequence(array: [moveOutAnimated, deleteTutorial, runGame])
            tiltTutorial.runAction(sequence)
            delegate.unpaused()
        }
    }
}
