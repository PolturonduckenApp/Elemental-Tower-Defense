//
//  GameScene.swift
//  Elemental Tower Defense
//
//  Created by Andrew Turley on 3/16/16.
//  Copyright (c) 2016 Polturonduken. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var screenWidth : CGFloat = 0
    var screenHeight : CGFloat = 0
    
    override func didMoveToView(view: SKView) {
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let mainMenuLabel = SKLabelNode(fontNamed: "Chalkduster")
        mainMenuLabel.text = "Main Menu"
        mainMenuLabel.fontSize = 45
        mainMenuLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        
        self.addChild(mainMenuLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location).name == "LevelOneButton" {
                let transition = SKTransition.revealWithDirection(.Left, duration: 1.0)
                
                let levelOne = LevelOne(size: scene!.size)
                levelOne.scaleMode = .AspectFill
                
                scene?.view?.presentScene(levelOne, transition: transition)
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
