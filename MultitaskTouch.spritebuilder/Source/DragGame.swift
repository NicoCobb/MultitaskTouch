//
//  DragGame.swift
//  MultitaskTouch
//
//  Created by nico cobb on 8/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class DragGame: CCNode {
    
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var topBorder: CCNode!
    weak var leftBorder: CCNode!
    weak var rightBorder: CCNode!
    weak var dragTutorial: CCNode!
    
    var pongBar: PongBar!
    var pongBall: CCSprite!
    var touchingBar = false
    var delegate: GameDelegate!
    var tutorialFinished = false
    var canMoveBar = true
    
//    var grabSpacePoint: CGPoint!
//    var grabSpaceBoxWidth: CGFloat!
//    var grabSpaceBoxHeight: CGFloat!
//    var grabSpaceBoxSize: CGSize!
//    var grabSpace: CGRect!
    var touchX: CGFloat?
    var spaceBetweenBarCenterAndTouch: CGFloat?

    var ballSpeed: CGFloat = 100
    var grabBuffer: CGFloat = 10
    var speedBuffer: CGFloat = 10
    
    func didLoadFromCCB() {
        //create game invisible and inactive
        opacity = 0
        cascadeOpacityEnabled = true
        userInteractionEnabled = false
        paused = true
//        gamePhysicsNode.debugDraw = true
    }
    
    override func onEnter() {
        super.onEnter()
        //topBar
        let sizeTop = CGRect(x: 0, y: 0, width: topBorder.boundingBox().width, height: topBorder.boundingBox().height)
        let physicsTop = CCPhysicsBody(rect: sizeTop, cornerRadius: 0)
        topBorder.physicsBody = physicsTop
        topBorder.physicsBody.affectedByGravity = false
        topBorder.physicsBody.allowsRotation = false
        topBorder.physicsBody.type = CCPhysicsBodyType.Static
        topBorder.physicsBody.elasticity = 1
        topBorder.physicsBody.friction = 0
        //leftBar
        let sizeLeft = CGRect(x: 0, y: 0, width: leftBorder.boundingBox().width, height: leftBorder.boundingBox().height)
        let physicsLeft = CCPhysicsBody(rect: sizeLeft, cornerRadius: 0)
        leftBorder.physicsBody = physicsLeft
        leftBorder.physicsBody.affectedByGravity = false
        leftBorder.physicsBody.allowsRotation = false
        leftBorder.physicsBody.type = CCPhysicsBodyType.Static
        leftBorder.physicsBody.elasticity = 1
        leftBorder.physicsBody.friction = 0
        //rightBar
        let sizeRight = CGRect(x: 0, y: 0, width: rightBorder.boundingBox().width, height: rightBorder.boundingBox().height)
        let physicsRight = CCPhysicsBody(rect: sizeRight, cornerRadius: 0)
        rightBorder.physicsBody = physicsRight
        rightBorder.physicsBody.affectedByGravity = false
        rightBorder.physicsBody.allowsRotation = false
        rightBorder.physicsBody.type = CCPhysicsBodyType.Static
        rightBorder.physicsBody.elasticity = 1
        rightBorder.physicsBody.friction = 0
        delegate.pauseGame()
    }
    
    //MARK: tutorial animation
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if tutorialFinished == false {
            tutorialFinished = true
            var moveOutAction = CCActionMoveTo(duration: 1.0, position: ccp(CGFloat(-2 * boundingBox().width), CGFloat(boundingBox().height / 2)))
            var moveOutAnimated = CCActionEaseElasticIn(action: moveOutAction, period: 1)
            var deleteTutorial = CCActionCallFunc(target: self, selector: "removeTutorial")
            var runGame = CCActionCallFunc(target: self, selector: "activateGame")
            var sequence = CCActionSequence(array: [moveOutAnimated, deleteTutorial, runGame])
            dragTutorial.runAction(sequence)
            delegate.unpaused()
        }
        
        let touchLocation = touch.locationInNode(self)
        
        var grabSpacePoint = ccp(pongBar.positionInPoints.x - pongBar.boundingBox().width/2 - grabBuffer/2, pongBar.positionInPoints.y - pongBar.boundingBox().height/2 - grabBuffer/2)
        var grabSpaceBoxWidth = pongBar.boundingBox().width * CGFloat(pongBar.scale) + grabBuffer
        var grabSpaceBoxHeight = pongBar.boundingBox().height * CGFloat(pongBar.scale) + grabBuffer
        var grabSpaceBoxSize = CGSize(width: grabSpaceBoxWidth, height: grabSpaceBoxHeight)
        var grabSpace = CGRect(origin: grabSpacePoint, size: grabSpaceBoxSize)
        
        var xBuffer = pongBar.contentSizeInPoints.width * CGFloat(pongBar.scale)
        
        if touchLocation.x > pongBar.positionInPoints.x - xBuffer &&
            touchLocation.x < pongBar.positionInPoints.x + xBuffer &&
            touchLocation.y > pongBar.positionInPoints.y - pongBar.contentSizeInPoints.height * CGFloat(pongBar.scale) &&
            touchLocation.y < pongBar.positionInPoints.y + pongBar.contentSizeInPoints.width * CGFloat(pongBar.scale){
            touchingBar = true
            spaceBetweenBarCenterAndTouch = touchLocation.x - pongBar.positionInPoints.x
        }
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if touchingBar == true {
            touchingBar = false
        }
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if touchingBar == true {
            if let barSpace = spaceBetweenBarCenterAndTouch {
                pongBar.positionInPoints.x = touch.locationInNode(self).x - barSpace
            }
        }
    }
    
    override func update(delta: CCTime) {
        var ballXVelocity = pongBall.physicsBody.velocity.x
        var ballYVelocity = pongBall.physicsBody.velocity.y
        
        //clamp ball speed
        if ballYVelocity > ballSpeed {
            pongBall.physicsBody.velocity.y = ballSpeed
        }
        
        if ballXVelocity > ballSpeed + speedBuffer {
            pongBall.physicsBody.velocity.x = ballSpeed + speedBuffer
        }

        //clamp bar position in node
            //check left boundary
        if (pongBar.positionInPoints.x) < 0 {
            canMoveBar = false
            pongBar.positionInPoints.x = 0
            //check right boundary
        } else if (pongBar.positionInPoints.x) >= 0 {
            canMoveBar = true
        }
        
        if (pongBar.positionInPoints.x) >= boundingBox().width {
            pongBar.positionInPoints.x = boundingBox().width
            canMoveBar = false
        } else if (pongBar.positionInPoints.x) <= boundingBox().width {
            canMoveBar = true
        }
        
        //GAME OVER TRIGGER
        if pongBall.positionInPoints.y < 0 {
            gameOver()
        }
        
    }
    
    func gameOver(){
        self.paused = true
        delegate.gameOver()
    }
    
    func raiseDifficulty() {
        ballSpeed += 20
        pongBall.physicsBody.applyImpulse(ccp(0, 20))
    }
    
    func removeTutorial() {
        dragTutorial.removeFromParent()
    }
    
    func activateGame() {
        pongBall.physicsBody.velocity = ccp(0, ballSpeed)
    }
    
    func showGame() {
        opacity = 1
        cascadeOpacityEnabled = true
        userInteractionEnabled = true
        paused = false
    }
}