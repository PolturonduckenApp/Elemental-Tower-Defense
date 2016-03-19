//
//  LevelTwo.swift
//  Elemental Tower Defense
//
//  Created by Andrew Turley on 3/19/16.
//  Copyright © 2016 Polturonduken. All rights reserved.
//

import UIKit
import SpriteKit

class LevelOne: SKScene {
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var screenWidth : CGFloat = 0
    var screenHeight : CGFloat = 0
    
    var rockTowers : [SKNode] = []
    var fireTowers : [SKNode] = []
    var airTowers : [SKNode] = []
    var waterTowers : [SKNode] = []
    var dragTower = false
    var curTowerType : String = ""
    var curTowerIndex = 0
    
    override func didMoveToView(view: SKView) {
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let levelOneLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelOneLabel.text = "Level One"
        levelOneLabel.name = "Level Label"
        levelOneLabel.fontSize = 45
        levelOneLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) + 300)

        let mainRock = SKSpriteNode(imageNamed: "Rock")
        mainRock.position.x = 100
        mainRock.position.y = 100
        mainRock.name = "Main Rock"
        mainRock.xScale = 0.3
        mainRock.yScale = 0.3
        
        let mainWater = SKSpriteNode(imageNamed: "Water")
        mainWater.position.x = 300
        mainWater.position.y = 100
        mainWater.name = "Main Water"
        mainWater.xScale = 0.5
        mainWater.yScale = 0.5
        
        let mainAir = SKSpriteNode(imageNamed: "Air")
        mainAir.position.x = 500
        mainAir.position.y = 100
        mainAir.name = "Main Air"
        mainAir.xScale = 0.5
        mainAir.yScale = 0.5
        
        let mainFire = SKSpriteNode(imageNamed: "Fire")
        mainFire.position.x = 700
        mainFire.position.y = 100
        mainFire.name = "Main Fire"
        mainFire.xScale = 0.5
        mainFire.yScale = 0.5
        
        self.addChild(mainRock)
        self.addChild(mainAir)
        self.addChild(mainWater)
        self.addChild(mainFire)
        self.addChild(levelOneLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location).name == "Main Rock" {
                let newTower = SKSpriteNode(imageNamed: "Rock")
                rockTowers.append(newTower)
                self.addChild(newTower)
                newTower.position = touch.locationInNode(self)
                newTower.name = "Rock"
                dragTower = true
                curTowerType = "Rock"
                curTowerIndex = rockTowers.count - 1
                newTower.xScale = 0.3
                newTower.yScale = 0.3
            }
            else if self.nodeAtPoint(location).name == "Main Water" {
                let newTower = SKSpriteNode(imageNamed: "Water")
                waterTowers.append(newTower)
                self.addChild(newTower)
                newTower.position = touch.locationInNode(self)
                newTower.name = "Water"
                dragTower = true
                curTowerType = "Water"
                curTowerIndex = waterTowers.count - 1
                newTower.xScale = 0.5
                newTower.yScale = 0.5
            }
            else if self.nodeAtPoint(location).name == "Main Air" {
                let newTower = SKSpriteNode(imageNamed: "Air")
                airTowers.append(newTower)
                self.addChild(newTower)
                newTower.position = touch.locationInNode(self)
                newTower.name = "Air"
                dragTower = true
                curTowerType = "Air"
                curTowerIndex = airTowers.count - 1
                newTower.xScale = 0.5
                newTower.yScale = 0.5
            }
            else if self.nodeAtPoint(location).name == "Main Fire" {
                let newTower = SKSpriteNode(imageNamed: "Fire")
                fireTowers.append(newTower)
                self.addChild(newTower)
                newTower.position = touch.locationInNode(self)
                newTower.name = "Fire"
                dragTower = true
                curTowerType = "Fire"
                curTowerIndex = fireTowers.count - 1
                newTower.xScale = 0.5
                newTower.yScale = 0.5
            }
            else {
                self.nodeAtPoint(location).position = location
                curTowerType = self.nodeAtPoint(location).name!
                if curTowerType == "Rock" {
                    curTowerIndex = rockTowers.indexOf(self.nodeAtPoint(location))!
                }
                else if curTowerType == "Water" {
                    curTowerIndex = waterTowers.indexOf(self.nodeAtPoint(location))!
                }
                else if curTowerType == "Air" {
                    curTowerIndex = airTowers.indexOf(self.nodeAtPoint(location))!
                }
                else if curTowerType == "Fire" {
                    curTowerIndex = fireTowers.indexOf(self.nodeAtPoint(location))!
                }
                dragTower = true
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            if dragTower == true {
                if curTowerType == "Rock" {
                    rockTowers[curTowerIndex].position = location
                }
                else if curTowerType == "Air" {
                    airTowers[curTowerIndex].position = location
                }
                else if curTowerType == "Water" {
                    waterTowers[curTowerIndex].position = location
                }
                else if curTowerType == "Fire" {
                    fireTowers[curTowerIndex].position = location
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        dragTower = false
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
