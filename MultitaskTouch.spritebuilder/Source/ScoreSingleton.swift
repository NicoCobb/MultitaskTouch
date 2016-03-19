//
//  ScoreSingleton.swift
//  MultitaskTouch
//
//  Created by nico cobb on 8/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class ScoreSingleton: NSObject {
    
//    var score = 0
//    var highScore = 0
//    static var instance = ScoreSingleton()

    static let sharedInstance = ScoreSingleton()
    
    var score: Int
    var highScore: Int = NSUserDefaults.standardUserDefaults().integerForKey("myHighScore") {
        didSet {
            NSUserDefaults.standardUserDefaults().setInteger(highScore, forKey:"myHighScore")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

    private override init() {
        score = 0
    }
}