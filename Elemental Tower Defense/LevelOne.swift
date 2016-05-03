//
//  LevelTwo.swift
//  Elemental Tower Defense
//
//  Created by Andrew Turley on 3/19/16.
//  Copyright © 2016 Polturonduken. All rights reserved.
//

import UIKit
import SpriteKit
import CoreGraphics
import Foundation

infix operator ** { associativity left precedence 170 }

func ** (num: Double, power: Double) -> Double{
    return pow(num, power)
}

class LevelOne: SKScene {
    //Determining screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var screenWidth : CGFloat = 0
    var screenHeight : CGFloat = 0
    
    //List of different towers + enemy
    var rockTowers : [Tower] = []
    var fireTowers : [SKNode] = []
    var airTowers : [SKNode] = []
    var waterTowers : [SKNode] = []
    var shadowPeople : [Enemy] = []
    var path : [Path] = []
    
    //Dragging tower to location in grid
    var dragTower = false
    var breakFromSearch = false
    var foundOpenSpace = false
    
    var curTowerType : String = "" //Current new tower type
    
    var grid : Grid! //Grid
    var shortPath : [ShortPath] = []
    
    var curTowerIndex = 0 //Current new tower index
    
    //Seperation between tiles in grid
    var widthSep : Double = 0.0
    var heightSep : Double = 0.0
    
    //Time to spawn new enemy
    var startTime = NSDate.timeIntervalSinceReferenceDate()
    var curTime: NSTimeInterval = 0
    var countDown = 10
    
    override func didMoveToView(view: SKView) {
        //Determines screen size
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        print(screenWidth)
        print(screenHeight)
        
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
        
        shortPath.append(ShortPath(x: 0, y: 10, number: 5))
        shortPath.append(ShortPath(x: 4, y: 11, number: 1))
        shortPath.append(ShortPath(x: 4, y: 12, number: 8))
        shortPath.append(ShortPath(x: 11, y: 11, number: 1))
        shortPath.append(ShortPath(x: 11, y: 10, number: 4))
        
        setUpPath(shortPath)
        
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
        mainRock.xScale = 0.1
        mainRock.yScale = 0.1
        mainRock.name = "Main Rock"
        
        let mainWater = SKSpriteNode(imageNamed: "Water")
        mainWater.position.x = 300
        mainWater.position.y = 100
        mainWater.name = "Main Water"
        
        let mainAir = SKSpriteNode(imageNamed: "Air")
        mainAir.position.x = 500
        mainAir.position.y = 100
        mainAir.name = "Main Air"
        
        let mainFire = SKSpriteNode(imageNamed: "Fire")
        mainFire.position.x = 700
        mainFire.position.y = 100
        mainFire.name = "Main Fire"
        
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
            print(self.nodeAtPoint(location).name)
            if self.nodeAtPoint(location).name == "Main Rock" {
                let newTower = Tower(element: "Rock", range: 100, power: 10, rate: 10, towerType: "turret", x: 0, y: 0, img: "Rock")
                rockTowers.append(newTower)
                self.addChild(newTower)
                newTower.position = touch.locationInNode(self)
                newTower.name = "Rock"
                dragTower = true
                curTowerType = "Rock"
                curTowerIndex = rockTowers.count - 1
                newTower.xScale = 0.5
                newTower.yScale = 0.5
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
                /**
                 * Determines type of new tower
                 */
                if let _ = self.nodeAtPoint(location).name {
                    self.nodeAtPoint(location).position = location
                    curTowerType = self.nodeAtPoint(location).name!
                    if curTowerType == "Rock" {
                        curTowerIndex = rockTowers.indexOf(self.nodeAtPoint(location) as! Tower)!
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
                else {
                    curTowerType = "nil"
                    curTowerIndex = -1
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
                    let close = nearestSpace("Rock")
                    if Double(rockTowers[curTowerIndex].position.x) - widthSep <= Double(grid.locations[x][y].x) && Double(rockTowers[curTowerIndex].position.x) + widthSep >= Double(grid.locations[x][y].x) && Double(rockTowers[curTowerIndex].position.y) - widthSep <= Double(grid.locations[x][y].y) && Double(rockTowers[curTowerIndex].position.y) + widthSep >= Double(grid.locations[x][y].y) && grid.towerList[x][y] == false {
                        rockTowers[curTowerIndex].position = grid.locations[close.x][close.y]
                        grid.towerList[close.x][close.y] = true
                        breakFromSearch = true
                        foundOpenSpace = true
                        break
                    }
                }
                else if curTowerType == "Air" {
                    let close = nearestSpace("Air")
                    if Double(airTowers[curTowerIndex].position.x) - widthSep <= Double(grid.locations[x][y].x) && Double(airTowers[curTowerIndex].position.x) + widthSep >= Double(grid.locations[x][y].x) && Double(airTowers[curTowerIndex].position.y) - widthSep <= Double(grid.locations[x][y].y) && Double(airTowers[curTowerIndex].position.y) + widthSep >= Double(grid.locations[x][y].y) && grid.towerList[x][y] == false {
                        airTowers[curTowerIndex].position = grid.locations[close.x][close.y]
                        grid.towerList[close.x][close.y] = true
                        breakFromSearch = true
                        foundOpenSpace = true
                        break
                    }
                }
                else if curTowerType == "Water" {
                    let close = nearestSpace("Water")
                    if Double(waterTowers[curTowerIndex].position.x) - widthSep <= Double(grid.locations[x][y].x) && Double(waterTowers[curTowerIndex].position.x) + widthSep >= Double(grid.locations[x][y].x) && Double(waterTowers[curTowerIndex].position.y) - widthSep <= Double(grid.locations[x][y].y) && Double(waterTowers[curTowerIndex].position.y) + widthSep >= Double(grid.locations[x][y].y) && grid.towerList[x][y] == false {
                        waterTowers[curTowerIndex].position = grid.locations[close.x][close.y]
                        grid.towerList[close.x][close.y] = true
                        breakFromSearch = true
                        foundOpenSpace = true
                        break
                    }
                }
                else if curTowerType == "Fire" {
                    let close = nearestSpace("Fire")
                    if Double(fireTowers[curTowerIndex].position.x) - widthSep <= Double(grid.locations[x][y].x) && Double(fireTowers[curTowerIndex].position.x) + widthSep >= Double(grid.locations[x][y].x) && Double(fireTowers[curTowerIndex].position.y) - widthSep <= Double(grid.locations[x][y].y) && Double(fireTowers[curTowerIndex].position.y) + widthSep >= Double(grid.locations[x][y].y) && grid.towerList[x][y] == false {
                        fireTowers[curTowerIndex].position = grid.locations[close.x][close.y]
                        grid.towerList[close.x][close.y] = true
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
        
        if elapsedTime >= 1 {
            startTime = curTime
            if countDown >= 0 {
                let newPerson = Enemy(type: "Enemy", defenseType: "Enemy", health: 100, speed: 10, gridX: 0, gridY: 10, x: Int(grid.locations[0][10].x), y: Int(grid.locations[0][10].y), imgName: "ShadowPerson")
                newPerson.position.y = screenHeight / 2
                newPerson.xScale = 0.1
                newPerson.yScale = 0.1
                shadowPeople.append(newPerson)
                self.addChild(newPerson)
                countDown = countDown - 1
            }
            
            for person in shadowPeople {
                if person.position.x > screenWidth {
                    shadowPeople.removeAtIndex(shadowPeople.indexOf(person)!)
                    person.removeFromParent()
                }
                else {
                    for paths in path {
                        if paths.xLoc == person.gridX && paths.yLoc == person.gridY && paths.forward != nil {
                            person.gridX = paths.forward.xLoc
                            person.gridY = paths.forward.yLoc
                            person.position = grid.locations[person.gridX][person.gridY]
                            break
                        }
                    }
                }
                
                if person.health <= 0 {
                    shadowPeople.removeAtIndex(shadowPeople.indexOf(person)!)
                    person.removeFromParent()
                }
                
                for tow in rockTowers {
                    if inVicinity(person, tower: tow) {
                        person.health = person.health - 50
                        print(person.health)
                    }
                }
            }
        }
    }
    
    func inVicinity(enemy: Enemy, tower: Tower) -> Bool {
        if sqrt((Double(enemy.position.x - tower.position.x))**2 + (Double(enemy.position.y - tower.position.y))**2) < Double(tower.range) {
            return true
        }
        return false
    }
    
    func nearestSpace(type: String) -> (x: Int, y: Int) {
        //Sets up variables for the smallest difference between points and the index for said points
        var smallestDiffX = CGFloat.max
        var smallestDiffY = CGFloat.max
        var smallestIndexX = 0
        var smallestIndexY = 0
        
        if type == "Rock" { //Takes in the type of the tower
            //Iterates through each and every possible cell
            for x in 0..<grid!.locations.count {
                for y in 0..<grid!.locations[x].count {
                    //If the tower is near an open space.....
                    if Double(rockTowers[curTowerIndex].position.x) - widthSep <= Double(grid!.locations[x][y].x) && Double(rockTowers[curTowerIndex].position.x) + widthSep >= Double(grid!.locations[x][y].x) && Double(rockTowers[curTowerIndex].position.y) - widthSep <= Double(grid!.locations[x][y].y) && Double(rockTowers[curTowerIndex].position.y) + widthSep >= Double(grid!.locations[x][y].y) && grid!.towerList[x][y] == false {
                        let temp = disBetweenPoints(rockTowers[curTowerIndex].position, target: grid!.locations[x][y]) //....finds difference between the two points....
                        
                        //....and if said difference is smaller than the smallest difference so far, set it as the new smallest difference and save the index
                        if temp.x < smallestDiffX && temp.y < smallestDiffY {
                            smallestDiffX = temp.x
                            smallestDiffY = temp.y
                            smallestIndexX = x
                            smallestIndexY = y
                        }
                    }
                }
            }
        }
        else if type == "Water" { //Takes in the type of the tower
            //Iterates through each and every possible cell
            for x in 0..<grid!.locations.count {
                for y in 0..<grid!.locations[x].count {
                    //If the tower is near an open space.....
                    if Double(waterTowers[curTowerIndex].position.x) - widthSep <= Double(grid!.locations[x][y].x) && Double(waterTowers[curTowerIndex].position.x) + widthSep >= Double(grid!.locations[x][y].x) && Double(waterTowers[curTowerIndex].position.y) - widthSep <= Double(grid!.locations[x][y].y) && Double(waterTowers[curTowerIndex].position.y) + widthSep >= Double(grid!.locations[x][y].y) && grid!.towerList[x][y] == false {
                        let temp = disBetweenPoints(waterTowers[curTowerIndex].position, target: grid!.locations[x][y]) //....finds difference between the two points....
                        
                        //....and if said difference is smaller than the smallest difference so far, set it as the new smallest difference and save the index
                        if temp.x < smallestDiffX && temp.y < smallestDiffY {
                            smallestDiffX = temp.x
                            smallestDiffY = temp.y
                            smallestIndexX = x
                            smallestIndexY = y
                        }
                    }
                }
            }
        } else if type == "Air" { //Takes in the type of the tower
            //Iterates through each and every possible cell
            for x in 0..<grid!.locations.count {
                for y in 0..<grid!.locations[x].count {
                    //If the tower is near an open space.....
                    if Double(airTowers[curTowerIndex].position.x) - widthSep <= Double(grid!.locations[x][y].x) && Double(airTowers[curTowerIndex].position.x) + widthSep >= Double(grid!.locations[x][y].x) && Double(airTowers[curTowerIndex].position.y) - widthSep <= Double(grid!.locations[x][y].y) && Double(airTowers[curTowerIndex].position.y) + widthSep >= Double(grid!.locations[x][y].y) && grid!.towerList[x][y] == false {
                        let temp = disBetweenPoints(airTowers[curTowerIndex].position, target: grid!.locations[x][y]) //....finds difference between the two points....
                        
                        //....and if said difference is smaller than the smallest difference so far, set it as the new smallest difference and save the index
                        if temp.x < smallestDiffX && temp.y < smallestDiffY {
                            smallestDiffX = temp.x
                            smallestDiffY = temp.y
                            smallestIndexX = x
                            smallestIndexY = y
                        }
                    }
                }
            }
        } else if type == "Fire" { //Takes in the type of the tower
            //Iterates through each and every possible cell
            for x in 0..<grid!.locations.count {
                for y in 0..<grid!.locations[x].count {
                    //If the tower is near an open space.....
                    if Double(fireTowers[curTowerIndex].position.x) - widthSep <= Double(grid!.locations[x][y].x) && Double(fireTowers[curTowerIndex].position.x) + widthSep >= Double(grid!.locations[x][y].x) && Double(fireTowers[curTowerIndex].position.y) - widthSep <= Double(grid!.locations[x][y].y) && Double(fireTowers[curTowerIndex].position.y) + widthSep >= Double(grid!.locations[x][y].y) && grid!.towerList[x][y] == false {
                        let temp = disBetweenPoints(fireTowers[curTowerIndex].position, target: grid!.locations[x][y]) //....finds difference between the two points....
                        
                        //....and if said difference is smaller than the smallest difference so far, set it as the new smallest difference and save the index
                        if temp.x < smallestDiffX && temp.y < smallestDiffY {
                            smallestDiffX = temp.x
                            smallestDiffY = temp.y
                            smallestIndexX = x
                            smallestIndexY = y
                        }
                    }
                }
            }
        }
        
        return (smallestIndexX, smallestIndexY)
    }
    
    func disBetweenPoints(base : CGPoint, target : CGPoint) -> (x: CGFloat, y: CGFloat) {
        //Takes in the x and y values of each point
        let baseX = base.x
        let baseY = base.y
        let targetX = target.x
        let targetY = target.y
        
        //Does some intense calculus to figure out the difference between the two x and y values
        let diffX = abs(targetX - baseX)
        let diffY = abs(targetY - baseY)
        
        return (diffX, diffY)
    }
    
    func setUpPath(pathList: [ShortPath]) {
        for point in pathList {
            for index in 0..<Int(point.number) {
                grid.towerList[Int(point.x + index)][Int(point.y)] = true
                let newPath = Path(forward: nil, backward: nil, x: Int(point.x + index), y: Int(point.y), img: "a")
                print("\(point.x + index) \(point.y)")
                self.addChild(newPath)
                path.append(newPath)
            }
        }
        
        for index in 0..<path.count {
            if index - 1 >= 0 {
                path[index].backward = path[index - 1]
            }
            
            if index + 1 < path.count {
                path[index].forward = path[index + 1]
            }
        }
        
        for paths in path {
            //self.addChild(paths)
            paths.position = grid.locations[paths.xLoc][paths.yLoc]
            paths.xScale = 0.3
            paths.yScale = 0.3
            paths.zPosition = -10
        }
    }
}
