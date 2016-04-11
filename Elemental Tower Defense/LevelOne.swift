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
    //Determining screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var screenWidth : CGFloat = 0
    var screenHeight : CGFloat = 0
    
    //List of different towers + enemy
    var rockTowers : [SKNode] = []
    var fireTowers : [SKNode] = []
    var airTowers : [SKNode] = []
    var waterTowers : [SKNode] = []
    var shadowPeople : [SKNode] = []
    
    //Dragging tower to location in grid
    var dragTower = false
    var breakFromSearch = false
    var foundOpenSpace = false
    
    var curTowerType : String = "" //Current new tower type
    
    var grid : Grid! //Grid
    
    var curTowerIndex = 0 //Current new tower index
    
    //Seperation between tiles in grid
    var widthSep : Double = 0.0
    var heightSep : Double = 0.0
    
    //Time to spawn new enemy
    var startTime = NSDate.timeIntervalSinceReferenceDate()
    var curTime: NSTimeInterval = 0
    
    override func didMoveToView(view: SKView) {
        //Determines screen size
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        var locations : [[CGPoint]] = [[CGPoint(x: 0.0, y: 0.0)]] //Locations of towers
        
        //Attempts to determine distance between tiles
        widthSep = Double(screenWidth / 15)
        heightSep = Double(screenHeight / 15)
        
        //Sets up grid
        for x in 0..<20 {
            locations.append([CGPoint(x: 0.0, y: 0.0)])
            for y in 0..<20 {
                locations[x].append(CGPoint(x: widthSep * Double(x), y: heightSep * Double(y)))
            }
        }
        
        grid = Grid(locations: locations) //Sets up grid pt. 2
        
        //Level One Title
        let levelOneLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelOneLabel.text = "Level One"
        levelOneLabel.name = "Level Label"
        levelOneLabel.fontSize = 45
        levelOneLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) + 300)
        
        /**
         * Sets up icons
         */
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
            let location = touch.locationInNode(self)//Find the location of the touch
            
            /**
             * • Determines which tower
             * • Creates a new tower and adds it to the list
             * • Sets up other necessary variables
             */
            if self.nodeAtPoint(location).name == "Main Rock" {
                let newTower = SKSpriteNode(imageNamed: "Rock")
                rockTowers.append(newTower)
                self.addChild(newTower)
                newTower.position = touch.locationInNode(self)
                newTower.name = "Rock"
                dragTower = true
                curTowerType = "Rock"
                curTowerIndex = rockTowers.count - 1
                newTower.xScale = 0.1
                newTower.yScale = 0.1
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
                newTower.xScale = 0.2
                newTower.yScale = 0.2
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
                newTower.xScale = 0.2
                newTower.yScale = 0.2
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
                newTower.xScale = 0.2
                newTower.yScale = 0.2
            }
            else {
                /**
                 * Determines type of new tower
                 */
                if let _ = self.nodeAtPoint(location).name {
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
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /**
         * • Literally just moves nodes with the position of your finger
         */
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
        /**
         * Alright here is where things get complicated
         */
        for x in 0..<grid.locations.count {
            for y in 0..<grid.locations[x].count {
                /**
                 * So as far as I can tell this is what this does:
                 * • Determines type of the new Tower type
                 * • Determines if there is an open space where the tower is dropped
                 * • If there is an open space, break from search, signal a found open space, put the tower there
                 */
                if curTowerType == "Rock" {
                    if Double(rockTowers[curTowerIndex].position.x) - widthSep <= Double(grid.locations[x][y].x) && Double(rockTowers[curTowerIndex].position.x) + widthSep >= Double(grid.locations[x][y].x) && Double(rockTowers[curTowerIndex].position.y) - widthSep <= Double(grid.locations[x][y].y) && Double(rockTowers[curTowerIndex].position.y) + widthSep >= Double(grid.locations[x][y].y) && grid.towerList[x][y] == false {
                        rockTowers[curTowerIndex].position = grid.locations[x][y]
                        grid.towerList[x][y] = true
                        breakFromSearch = true
                        foundOpenSpace = true
                        break
                    }
                }
                else if curTowerType == "Air" {
                    if Double(airTowers[curTowerIndex].position.x) - widthSep <= Double(grid.locations[x][y].x) && Double(airTowers[curTowerIndex].position.x) + widthSep >= Double(grid.locations[x][y].x) && Double(airTowers[curTowerIndex].position.y) - widthSep <= Double(grid.locations[x][y].y) && Double(airTowers[curTowerIndex].position.y) + widthSep >= Double(grid.locations[x][y].y) && grid.towerList[x][y] == false {
                        airTowers[curTowerIndex].position = grid.locations[x][y]
                        grid.towerList[x][y] = true
                        breakFromSearch = true
                        foundOpenSpace = true
                        break
                    }
                }
                else if curTowerType == "Water" {
                    if Double(waterTowers[curTowerIndex].position.x) - widthSep <= Double(grid.locations[x][y].x) && Double(waterTowers[curTowerIndex].position.x) + widthSep >= Double(grid.locations[x][y].x) && Double(waterTowers[curTowerIndex].position.y) - widthSep <= Double(grid.locations[x][y].y) && Double(waterTowers[curTowerIndex].position.y) + widthSep >= Double(grid.locations[x][y].y) && grid.towerList[x][y] == false {
                        waterTowers[curTowerIndex].position = grid.locations[x][y]
                        grid.towerList[x][y] = true
                        breakFromSearch = true
                        foundOpenSpace = true
                        break
                    }
                }
                else if curTowerType == "Fire" {
                    if Double(fireTowers[curTowerIndex].position.x) - widthSep <= Double(grid.locations[x][y].x) && Double(fireTowers[curTowerIndex].position.x) + widthSep >= Double(grid.locations[x][y].x) && Double(fireTowers[curTowerIndex].position.y) - widthSep <= Double(grid.locations[x][y].y) && Double(fireTowers[curTowerIndex].position.y) + widthSep >= Double(grid.locations[x][y].y) && grid.towerList[x][y] == false {
                        fireTowers[curTowerIndex].position = grid.locations[x][y]
                        grid.towerList[x][y] = true
                        breakFromSearch = true
                        foundOpenSpace = true
                        break
                    }
                }
            }
            if breakFromSearch == true {
                breakFromSearch = false
                break
            }
        }
        
        /**
         * If found open space, remove the rock from the parent and from the tower list
         */
        if foundOpenSpace == false {
            if curTowerType == "Rock" {
                rockTowers[curTowerIndex].removeFromParent()
                rockTowers.removeAtIndex(curTowerIndex)
            }
            else if curTowerType == "Water" {
                waterTowers[curTowerIndex].removeFromParent()
                waterTowers.removeAtIndex(curTowerIndex)
            }
            else if curTowerType == "Air" {
                airTowers[curTowerIndex].removeFromParent()
                airTowers.removeAtIndex(curTowerIndex)
            }
            else if curTowerType == "Fire" {
                fireTowers[curTowerIndex].removeFromParent()
                fireTowers.removeAtIndex(curTowerIndex)
            }
        }
        
        foundOpenSpace = false
        
        dragTower = false
    }
    
    override func update(currentTime: CFTimeInterval) {
        /**
         * Spawns enemies every five secons
         */
        curTime = NSDate.timeIntervalSinceReferenceDate()
        let elapsedTime = curTime - startTime
        if elapsedTime >= 5 {
            startTime = curTime
            let newPerson = SKSpriteNode(imageNamed: "ShadowPerson")
            newPerson.position.y = screenHeight / 2
            shadowPeople.append(newPerson)
            self.addChild(newPerson)
        }
        
        for person in shadowPeople {
            person.position.x += 5
        }
    }
}
