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
    
    var pongBar: PongBar!
    var pongBall: CCSprite!
    var touchingBar = false
    
    var grabSpacePoint: CGPoint!
    var grabSpaceBoxWidth: CGFloat!
    var grabSpaceBoxHeight: CGFloat!
    var grabSpaceBoxSize: CGSize!
    var grabSpace: CGRect!
    var touchX: CGFloat?
    
    var ballSpeed: CGFloat = 150
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        pongBall.physicsBody.velocity = ccp(0, -ballSpeed)
        gamePhysicsNode.debugDraw = true
        grabSpacePoint = pongBar.positionInPoints
        grabSpaceBoxWidth = pongBar.bar.boundingBox().width
        grabSpaceBoxHeight = pongBar.bar.boundingBox().height
        grabSpaceBoxSize = CGSize(width: grabSpaceBoxWidth, height: grabSpaceBoxHeight)
        grabSpace = CGRect(origin: grabSpacePoint, size: grabSpaceBoxSize)
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
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        let touchLocation = touch.locationInNode(self)
        println("pongBar bar boundingBox: \(pongBar.bar.boundingBox())")
        println("pongBar Position: \(pongBar.positionInPoints)")
        println("grabSpace: \(grabSpace)")
        println("touch Position: \(touchLocation)")
        
        if grabSpace.contains(touchLocation) {
            println("touching bar")
            touchingBar = true
        }
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if touchingBar == true {
            touchingBar = false
        }
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if touchingBar == true {
            pongBar.position.x = touch.locationInNode(self).x
        }
    }
    
    override func update(delta: CCTime) {
        grabSpacePoint = pongBar.positionInPoints
        grabSpaceBoxWidth = pongBar.bar.boundingBox().width
        grabSpaceBoxHeight = pongBar.bar.boundingBox().height
        grabSpaceBoxSize = CGSize(width: grabSpaceBoxWidth, height: grabSpaceBoxHeight)
        grabSpace = CGRect(origin: grabSpacePoint, size: grabSpaceBoxSize)
    }
}