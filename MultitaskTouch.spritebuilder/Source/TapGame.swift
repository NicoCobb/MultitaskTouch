//
//  TapGame.swift
//  MultitaskTouch
//
//  Created by nico cobb on 8/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class TapGame: CCNode {

    var currentTiles = [TapTile]()

    var randomTileSpawn = arc4random_uniform(0)
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        var randomTileSpawnTime = CCTime(randomTileSpawn)
        scheduleOnce("generateTapBlock", delay: randomTileSpawnTime)
    }
    
    func generateTapBlock() {
        //select enemy location
        self.unschedule("generateTapBlock")
        
        var spawnedTile = CCBReader.load("TapTile") as! TapTile
        var tileXPosition = CGFloat(arc4random_uniform(UInt32(self.contentSizeInPoints.width)))
        var tileYPosition = CGFloat(arc4random_uniform(UInt32(self.contentSizeInPoints.height)))
        var tileSpawnPoint = ccp(tileXPosition, tileYPosition)
        spawnedTile.position = tileSpawnPoint
        
        self.addChild(spawnedTile)
        println(spawnedTile.tapBlock.boundingBox())
        println(spawnedTile.position)
        
        //generate tiles between 2 and 4 seconds
        randomTileSpawn = arc4random_uniform(3) + 2
        var randomTileSpawnTime = CCTime(randomTileSpawn)
        scheduleOnce("generateTapBlock", delay: randomTileSpawnTime)
    }
    
}