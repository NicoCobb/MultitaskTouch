//
//  SwipeGame.swift
//  MultitaskTouch
//
//  Created by nico cobb on 8/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class SwipeGame: CCNode, CCPhysicsCollisionDelegate {
   
    weak var swipeSensor: CCNode!
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var swipeTutorial: CCNode!
    
    var randomTileSpawn = arc4random_uniform(0)
        //continual 4 seconds w/ random 0 or 1 extra second = 3-5 seconds
    var randomTileSpawnBaseTime: CCTime = 4
    var startTouchPosition: CGPoint?
    var endTouchPosition: CGPoint?
    var blockMoveSpeedIncrease: Double = 0
    var tutorialFinished = false
    
    var runSwipeCheck = false
    var swipeRemove = false
    var currentBlock: SwipeTile?
    var currentBlocks: [SwipeTile]?
    var delegate: GameDelegate!
    
    func didLoadFromCCB() {
        //create game invisible and inactive
        opacity = 0
        cascadeOpacityEnabled = true
        userInteractionEnabled = false
        paused = true
        userInteractionEnabled = true
        //gamePhysicsNode.debugDraw = true
        gamePhysicsNode.collisionDelegate = self
    }
    
    override func onEnter() {
        super.onEnter()
        let size = CGRect(x: 0, y: 0, width: swipeSensor.boundingBox().width, height: swipeSensor.boundingBox().height)
        let physics = CCPhysicsBody(rect: size, cornerRadius: 0)
        swipeSensor.physicsBody = physics
        swipeSensor.physicsBody.affectedByGravity = false
        swipeSensor.physicsBody.allowsRotation = false
        swipeSensor.physicsBody.sensor = true
        swipeSensor.physicsBody.collisionType = "swipeSensor"
    }
    
    func generateSwipeBlock() {
        //select block location
        self.unschedule("generateSwipeBlock")
        var tileYPosition = CGFloat(arc4random_uniform(UInt32(contentSizeInPoints.height)))
        var tileSpawnPoint = ccp((0), (tileYPosition))
        var spawnedTile = CCBReader.load("SwipeTile") as! SwipeTile
        spawnedTile.blockMoveSpeed += blockMoveSpeedIncrease
        spawnedTile.scale = 0.5
        spawnedTile.position = tileSpawnPoint
        gamePhysicsNode.addChild(spawnedTile)
        
        //generate tiles between 3 and 5 seconds
    }
    
    func startGeneratingSwipeBlocks() {
        randomTileSpawn = arc4random_uniform(2)
        var randomTileSpawnTime = CCTime(randomTileSpawn)
        scheduleOnce("generateSwipeBlock", delay: randomTileSpawnTime)
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, swipeSensor: CCNode!, swipeTile: SwipeTile!) -> Bool {
        currentBlock = swipeTile
//        currentBlocks.append(swipeTile)
        return false
    }
    
    func ccPhysicsCollisionSeparate(pair: CCPhysicsCollisionPair!, swipeSensor: CCNode!, swipeTile: SwipeTile!) {
        if swipeRemove == true {
            swipeRemove = false
            return
        }
        gameOver()
    }
    
    //if they swipe in the right direction in the node, then remove it from the scene
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if tutorialFinished == false {
            tutorialFinished = true
            var moveInAction = CCActionMoveTo(duration: 1.0, position: ccp(CGFloat(2 * boundingBox().width), CGFloat(boundingBox().height * 0.0)))
            var moveInAnimated = CCActionEaseElasticIn(action: moveInAction, period: 1)
            var deleteTutorial = CCActionCallFunc(target: self, selector: "removeTutorial")
            var runGame = CCActionCallFunc(target: self, selector: "activateGame")
            var sequence = CCActionSequence(array: [moveInAnimated, deleteTutorial, runGame])
            swipeTutorial.runAction(sequence)
            delegate.unpaused()
        }
        
        let touchLocation = touch.locationInNode(self)
        if swipeSensor.boundingBox().contains(touchLocation) {
            startTouchPosition = touchLocation
        }
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        endTouchPosition = touch.locationInNode(self)
        
        var swipeYLength: CGFloat = 0
        var swipeXLength: CGFloat = 0
        
        if let endTouch = endTouchPosition {
            if let startTouch = startTouchPosition {
                swipeYLength = endTouch.y - startTouch.y
                swipeXLength = endTouch.x - startTouch.x
            }
        }
        
        //unwrap block and don't run func if nil
        if let activeBlock = currentBlock{
            //check if swipe was vertical
            if abs(swipeYLength) >= abs(swipeXLength) {
                //check if swipe was up for Up block
                if swipeYLength >= 0 {
                    if activeBlock.blockDirection == .Up {
                        swipeRemove = true
                        removeTile(activeBlock)
                    }
                //check if swipe was down for Down block
                } else {
                    if activeBlock.blockDirection == .Down {
                        swipeRemove = true
                        removeTile(activeBlock)
                    }
                }
            //check if swipe was right for Right block
            } else {
                if swipeXLength >= 0 {
                    if activeBlock.blockDirection == .Right {
                        swipeRemove = true
                        removeTile(activeBlock)
                    }
                } else {
                    if activeBlock.blockDirection == .Left {
                        swipeRemove = true
                        removeTile(activeBlock)
                    }
                }
            }
        }
    }
    
    func removeTile(tile: SwipeTile) {
        tile.removeFromParent()
        currentBlock = nil
    }
    
    func gameOver(){
        delegate.gameOver()
        self.paused = true
    }
    
    func raiseDifficulty() {
        if randomTileSpawnBaseTime > 0 {
            randomTileSpawnBaseTime -= 1
            unschedule("startGeneratingSwipeBlocks")
            schedule("startGeneratingSwipeBlocks", interval: randomTileSpawnBaseTime)
        } else {
            blockMoveSpeedIncrease += 0.5
        }
    }
    
    func removeTutorial() {
        swipeTutorial.removeFromParent()
    }
    
    func activateGame() {
        schedule("startGeneratingSwipeBlocks", interval: randomTileSpawnBaseTime)
        generateSwipeBlock()
    }
    
    func showGame() {
        opacity = 1
        cascadeOpacityEnabled = true
        userInteractionEnabled = true
        paused = false
    }
    
}