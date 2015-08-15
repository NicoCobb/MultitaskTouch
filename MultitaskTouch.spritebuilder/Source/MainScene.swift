
import Foundation

class MainScene: CCNode {

    weak var playButton: CCButton!
    weak var settingsButton: CCButton!
    weak var leaderboardsButton: CCButton!
    weak var infoButton: CCButton!
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        
    }
    
    func play() {
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene)
    }

    func info() {
        var infoScreen = CCBReader.load("Info", owner: self)
        self.addChild(infoScreen)
    }
    
    func exitInfo() {
        removeChildByName("Info")
    }
    
    func stats() {
        let statsScene = CCBReader.loadAsScene("Stats")
        CCDirector.sharedDirector().presentScene(statsScene)
    }
    
    func settings() {
        let settings = CCBReader.loadAsScene("Settings")
        CCDirector.sharedDirector().presentScene(settings)
    }
}
