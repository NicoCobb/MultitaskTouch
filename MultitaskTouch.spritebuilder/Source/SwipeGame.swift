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
    
    var randomTileSpawn = arc4random_uniform(0)
    var startTouchPosition: CGPoint?
    var endTouchPosition: CGPoint?
    
    var runSwipeCheck = false
    var swipeRemove = false
    var currentBlock: SwipeTile?
    var delegate: GameDelegate!
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
//        gamePhysicsNode.debugDraw = true
        gamePhysicsNode.collisionDelegate = self
        var randomTileSpawnTime = CCTime(randomTileSpawn)
        scheduleOnce("generateSwipeBlock", delay: randomTileSpawnTime)
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
//        self.unschedule("generateSwipeBlock")
        var tileYPosition = CGFloat(arc4random_uniform(UInt32(contentSizeInPoints.height)))
        var tileSpawnPoint = ccp((0), (tileYPosition))
        var spawnedTile = CCBReader.load("SwipeTile") as! SwipeTile
        spawnedTile.scale = 0.5
        spawnedTile.position = tileSpawnPoint
        gamePhysicsNode.addChild(spawnedTile)
        
        //generate tiles between 3 and 5 seconds
        randomTileSpawn = arc4random_uniform(3) + 3
        var randomTileSpawnTime = CCTime(randomTileSpawn)
        scheduleOnce("generateSwipeBlock", delay: randomTileSpawnTime)
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, swipeSensor: CCNode!, swipeTile: SwipeTile!) -> Bool {
        currentBlock = swipeTile
        println(swipeTile.blockDirection)
        return false
    }
    
    func ccPhysicsCollisionSeparate(pair: CCPhysicsCollisionPair!, swipeSensor: CCNode!, swipeTile: SwipeTile!) {
        if swipeRemove == true {
            swipeRemove = false
            return
        }
        gameOver()
    }
    
    func swipeGameOver() {
        parent.paused = true
        unschedule("generateSwipeBlock")
    }
    
    //if they swipe in the right direction in the node, then remove it from the scene
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        let touchLocation = touch.locationInNode(self)
        if swipeSensor.boundingBox().contains(touchLocation) {
            startTouchPosition = touchLocation
            println("startTouchPosition: \(startTouchPosition)")
        }
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        endTouchPosition = touch.locationInNode(self)
        println("endTouchPosition: \(endTouchPosition)")

        
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
            println("block Direction: \(activeBlock.rotation)")
            println("swipeYLength: \(swipeYLength)")
            println("swipeXLength: \(swipeXLength)")
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
    }
    
}