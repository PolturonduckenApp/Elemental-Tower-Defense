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

func ** (num: Double, power: Double) -> Double {
    return pow(num, power)
}

func ** (num: CGFloat, power: CGFloat) -> CGFloat {
    return pow(num, power)
}

class LevelOne: SKScene {
    //Determining screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var screenWidth : CGFloat = 0
    var screenHeight : CGFloat = 0
    
    //List of different towers + enemy
    var rockTowers : [Tower] = []
    var fireTowers : [Tower] = []
    var airTowers : [Tower] = []
    var waterTowers : [Tower] = []
    var shadowPeople : [Enemy] = []
    var projectiles : [Projectile] = []
    var path : [Path] = []
    
    //Dragging tower to location in grid
    var dragTower = false
    var breakFromSearch = false
    var foundOpenSpace = false
    
    var projectile : Projectile!
    var spawnedProjectile = false
    
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
        
        let newNormalEnemy = SKLabelNode(fontNamed: "Chalkduster") //Spawns new normal enemy
        newNormalEnemy.text = "Spawn Normal"
        newNormalEnemy.name = "SpawnNormal"
        newNormalEnemy.fontSize = 45
        newNormalEnemy.position = CGPoint(x: screenWidth * 1/4, y: screenHeight * 8/9)
        
        let newInvincible = SKLabelNode(fontNamed: "Chalkduster") //Spanws new invincible enemy
        newInvincible.text = "Spawn Invincible"
        newInvincible.name = "SpawnInvincible"
        newInvincible.fontSize = 45
        newInvincible.position = CGPoint(x: screenWidth * 3/4, y: screenHeight * 8/9)
        
        let levelOneLabel = SKLabelNode(fontNamed: "Chalkduster") //Level One label
        levelOneLabel.text = "Level One"
        levelOneLabel.name = "Level Label"
        levelOneLabel.fontSize = 45
        levelOneLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: screenHeight * 7/9 + 43)
        
        
        var locations : [[CGPoint]] = [[CGPoint(x: 0.0, y: 0.0)]] //Locations of towers
        
        //Attempts to determine distance between tiles
        widthSep = Double(screenWidth / 15)
        heightSep = Double(screenHeight / 15)
        
        //Sets up grid
        for x in 0..<15 {
            locations.append([CGPoint(x: 0.0, y: 0.0)])
            for y in 0..<15 {
                locations[x].append(CGPoint(x: widthSep * Double(x), y: heightSep * Double(y)))
            }
        }
        
        grid = Grid(locations: locations) //Sets up grid pt. 2
        
        //Shorthand method of setting up a path
        shortPath.append(ShortPath(x: 0, y: 10, number: 5))
        shortPath.append(ShortPath(x: 4, y: 11, number: 1))
        shortPath.append(ShortPath(x: 4, y: 12, number: 8))
        shortPath.append(ShortPath(x: 11, y: 11, number: 1))
        shortPath.append(ShortPath(x: 11, y: 10, number: 4))
        
        setUpPath(shortPath)
        
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
        self.addChild(newNormalEnemy)
        self.addChild(newInvincible)
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
                let newTower = Tower(element: "Rock", range: 100, power: 10, rate: 10, towerType: "turret", x: 0, y: 0, img: "Rock") //Sets up new tower
                rockTowers.append(newTower) //Adds it to the tower list
                self.addChild(newTower) //Puts it on the screen
                newTower.position = touch.locationInNode(self) //Places it where the user touched
                newTower.name = "Rock"
                dragTower = true
                curTowerType = "Rock"
                curTowerIndex = rockTowers.count - 1
                newTower.xScale = 0.5
                newTower.yScale = 0.5
            }
            else if self.nodeAtPoint(location).name == "Main Water" {
                let newTower = Tower(element: "Water", range: 200, power: 10, rate: 10, towerType: "turret", x: 0, y: 0, img: "Water")
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
                let newTower = Tower(element: "Air", range: 100, power: 10, rate: 10, towerType: "turret", x: 0, y: 0, img: "Air")
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
                let newTower = Tower(element: "Fire", range: 100, power: 10, rate: 10, towerType: "turret", x: 0, y: 0, img: "Fire")
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
            else if self.nodeAtPoint(location).name == "SpawnNormal" {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in //Sets up new thread
                    let person = Enemy(type: "Enemy", defenseType: "Enemy", health: 100, speed: 10, gridX: 0, gridY: 10, x: Int(self.grid.locations[0][10].x), y: Int(self.grid.locations[0][10].y), imgName: "ShadowPerson") //Sets up new enemy with normal health
                    person.position.y = self.screenHeight / 2 //Half the screen height
                    person.xScale = 0.1
                    person.yScale = 0.1
                    self.shadowPeople.append(person)
                    self.addChild(person)
                    
                    while true { //Keep going until the enemy dies or goes off the screen
                        if person.position.x > self.screenWidth { //If the enemy is off the screen
                            self.shadowPeople.removeAtIndex(self.shadowPeople.indexOf(person)!) //Remove the enemy
                            person.removeFromParent()
                            break //Break from the while true loop and end the thread
                        }
                        else {
                            for paths in self.path { //Loop through each path tile to see which one the enemy goes to next
                                if paths.xLoc == person.gridX && paths.yLoc == person.gridY && paths.forward != nil { //If this tile is the one the enemy is on, AND the next tile exists
                                    person.gridX = paths.forward.xLoc //Set the person to be on the next tile
                                    person.gridY = paths.forward.yLoc
                                    let time = person.moveTo(paths.forward.position.x, y: paths.forward.position.y, speed: 100) //Move to the next tile
                                    usleep(UInt32(time * 1000000)) //Wait until the enemy has moved to the next tile
                                    break
                                }
                                else if paths.forward == nil { //Otherwise if there is no next tile
                                    person.health = -1 //Kill the enemy
                                }
                            }
                        }
                        
                        if person.health <= 0 { //If the enemy is dead
                            self.shadowPeople.removeAtIndex(self.shadowPeople.indexOf(person)!) //Remove the enemy
                            person.removeFromParent()
                            break //Break from the while true loop and end the thread
                        }
                    }
                }
            }
            else if self.nodeAtPoint(location).name == "SpawnInvincible" {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in //Sets up new thread
                    let person = Enemy(type: "Enemy", defenseType: "Enemy", health: 10000000, speed: 10, gridX: 0, gridY: 10, x: Int(self.grid.locations[0][10].x), y: Int(self.grid.locations[0][10].y), imgName: "ShadowPerson")
                    person.position.y = self.screenHeight / 2
                    person.xScale = 0.1
                    person.yScale = 0.1
                    self.shadowPeople.append(person)
                    self.addChild(person)
                    
                    while true { //Keep going until the enemy dies or goes off the screen
                        if person.position.x > self.screenWidth { //If the enemy is off the screen
                            self.shadowPeople.removeAtIndex(self.shadowPeople.indexOf(person)!) //Remove the enemy
                            person.removeFromParent()
                            break //Break from the while true loop and end the thread
                        }
                        else {
                            for paths in self.path { //Loop through each path tile to see which one the enemy goes to next
                                if paths.xLoc == person.gridX && paths.yLoc == person.gridY && paths.forward != nil { //If this tile is the one the enemy is on, AND the next tile exists
                                    person.gridX = paths.forward.xLoc //Set the person to be on the next tile
                                    person.gridY = paths.forward.yLoc
                                    let time = person.moveTo(paths.forward.position.x, y: paths.forward.position.y, speed: 100) //Move to the next tile
                                    usleep(UInt32(time * 1000000)) //Wait until the enemy has moved to the next tile
                                    break
                                }
                                else if paths.forward == nil { //Otherwise if there is no next tile
                                    person.health = -1 //Kill the enemy
                                }
                            }
                        }
                        
                        if person.health <= 0 { //If the enemy is dead
                            self.shadowPeople.removeAtIndex(self.shadowPeople.indexOf(person)!) //Remove the enemy
                            person.removeFromParent()
                            break //Break from the while true loop and end the thread
                        }
                    }
                }
            }
            else if self.nodeAtPoint(location).name != "Level Label" {
                /**
                 * Determines type of new tower
                 */
                if let _ = self.nodeAtPoint(location).name {
                    self.nodeAtPoint(location).position = location
                    curTowerType = self.nodeAtPoint(location).name!
                    if curTowerType == "Rock" {
                        curTowerIndex = rockTowers.indexOf(self.nodeAtPoint(location) as! Tower)!
                        dragTower = true
                    }
                    else if curTowerType == "Water" {
                        curTowerIndex = waterTowers.indexOf(self.nodeAtPoint(location) as! Tower)!
                        dragTower = true
                    }
                    else if curTowerType == "Air" {
                        curTowerIndex = airTowers.indexOf(self.nodeAtPoint(location) as! Tower)!
                        dragTower = true
                    }
                    else if curTowerType == "Fire" {
                        curTowerIndex = fireTowers.indexOf(self.nodeAtPoint(location) as! Tower)!
                        dragTower = true
                    }
                }
                else {
                    curTowerType = "nil"
                    curTowerIndex = -1
                }
            }
            else {
                dragTower = false
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
        if dragTower {
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
    }
    
    override func update(currentTime: CFTimeInterval) {
        startWave()
        if !projectiles.isEmpty {
            for var index in 0..<projectiles.count {
                if index >= projectiles.count {
                    break
                }
                updateProjectile(index)
                index = index + 0
            }
        }
    }
    
    func updateProjectile(index: Int) {
        let gee = Double(projectiles[index].direction.dx)**2 + Double(projectiles[index].direction.dy)**2
        
        projectiles[index].position.y += ((projectiles[index].direction.dy) * (CGFloat(gee) + projectiles[index].speed))/CGFloat(gee)
        projectiles[index].position.x += ((projectiles[index].direction.dx) * (CGFloat(gee) + projectiles[index].speed))/CGFloat(gee)
        
        if projectiles[index].position.x > screenWidth || projectiles[index].position.x < 0 || projectiles[index].position.y > screenHeight || projectiles[index].position.y < 0 {
            projectiles[index].removeFromParent()
            projectiles.removeAtIndex(index)
        }
    }
    
    func startWave() {
        /**
         * Spawns enemies every five secons
         */
        curTime = NSDate.timeIntervalSinceReferenceDate()
        let elapsedTime = curTime - startTime
        
        if elapsedTime >= 1 {
            startTime = curTime
            if countDown >= 0 {
                //Uh oh
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in //Sets up new thread
                    let person = Enemy(type: "Enemy", defenseType: "Enemy", health: 100, speed: 10, gridX: 0, gridY: 10, x: Int(self.grid.locations[0][10].x), y: Int(self.grid.locations[0][10].y), imgName: "ShadowPerson") //Creates new enemy
                    person.position.y = self.screenHeight / 2
                    person.xScale = 0.1
                    person.yScale = 0.1
                    self.shadowPeople.append(person)
                    self.addChild(person)
                    self.countDown = self.countDown - 1
                    
                    while true { //Keep going until the enemy dies or goes off the screen
                        if person.position.x > self.screenWidth { //If the enemy is off the screen
                            self.shadowPeople.removeAtIndex(self.shadowPeople.indexOf(person)!) //Remove the enemy
                            person.removeFromParent()
                            break //Break from the while true loop and end the thread
                        }
                        else {
                            for paths in self.path { //Loop through each path tile to see which one the enemy goes to next
                                if paths.xLoc == person.gridX && paths.yLoc == person.gridY && paths.forward != nil { //If this tile is the one the enemy is on, AND the next tile exists
                                    person.gridX = paths.forward.xLoc //Set the person to be on the next tile
                                    person.gridY = paths.forward.yLoc
                                    let time = person.moveTo(paths.forward.position.x, y: paths.forward.position.y, speed: 100) //Move to the next tile
                                    usleep(UInt32(time * 1000000)) //Wait until the enemy has moved to the next tile
                                    break
                                }
                                else if paths.forward == nil { //Otherwise if there is no next tile
                                    person.health = -1 //Kill the enemy
                                }
                            }
                        }
                        
                        if person.health <= 0 { //If the enemy is dead
                            self.shadowPeople.removeAtIndex(self.shadowPeople.indexOf(person)!) //Remove the enemy
                            person.removeFromParent()
                            break //Break from the while true loop and end the thread
                        }
                    }
                }
            }
            spawnedProjectile = false
        }
        
        if elapsedTime >= 0.5 && spawnedProjectile == false { //Every half of a second
            for person in shadowPeople { //Loop through each person
                for tow in rockTowers { //Loop through each tower
                    if inVicinity(person, tower: tow) { //If there is a person in the range of the tower
                        person.health = person.health - tow.power //Hurt the enemy
                        let projectile = Projectile(speed: 100, power: 100, direction: CGVector(dx: person.position.x - CGFloat(tow.xLoc), dy: person.position.y - CGFloat(tow.yLoc)), image: "Spaceship") //Spawns a new projectile
                        
                        projectile.position.x = tow.position.x //Sets the projectile position to be at the tower position
                        projectile.position.y = tow.position.y
                        
                        projectile.rotate(person, tower: tow) //Rotate the projectile to be facing the enemy
                        tow.rotate(person, tower: tow)
                        
                        projectile.size.width = 20 //Reduce the size of the projectile
                        projectile.size.width = 20
                        
                        projectiles.append(projectile) //Add it to the list of all projectiles
                        self.addChild(projectile)
                    }
                }
                
                for tow in waterTowers {
                    if inVicinity(person, tower: tow) {
                        person.health = person.health - 50
                        let projectile = Projectile(speed: 1, power: 100, direction: CGVector(dx: (person.position.x - CGFloat(tow.position.x)) / 20, dy: (person.position.y - CGFloat(tow.position.y)) / 20), image: "Spaceship")
                        
                        projectile.position.x = tow.position.x
                        projectile.position.y = tow.position.y
                        
                        projectile.rotate(person, tower: tow)
                        tow.rotate(person, tower: tow)
                        
                        projectile.size.width = 20
                        projectile.size.width = 20
                        
                        projectiles.append(projectile)
                        self.addChild(projectile)
                    }
                }
                
                for tow in airTowers {
                    if inVicinity(person, tower: tow) {
                        person.health = person.health - 50
                        let projectile = Projectile(speed: 100, power: 100, direction: CGVector(dx: person.position.x - CGFloat(tow.xLoc), dy: person.position.y - CGFloat(tow.yLoc)), image: "Spaceship")
                        
                        projectile.position.x = tow.position.x
                        projectile.position.y = tow.position.y
                        
                        projectile.rotate(person, tower: tow)
                        tow.rotate(person, tower: tow)
                        
                        projectile.size.width = 20
                        projectile.size.width = 20
                        
                        projectiles.append(projectile)
                        self.addChild(projectile)
                    }
                }
                
                for tow in fireTowers {
                    if inVicinity(person, tower: tow) {
                        person.health = person.health - 50
                        let projectile = Projectile(speed: 100, power: 100, direction: CGVector(dx: person.position.x - CGFloat(tow.xLoc), dy: person.position.y - CGFloat(tow.yLoc)), image: "Spaceship")
                        
                        projectile.position.x = tow.position.x
                        projectile.position.y = tow.position.y
                        
                        projectile.rotate(person, tower: tow)
                        tow.rotate(person, tower: tow)
                        
                        projectile.size.width = 20
                        projectile.size.width = 20
                        
                        projectiles.append(projectile)
                        self.addChild(projectile)
                    }
                }
            }
            spawnedProjectile = true
        }
        
        for person in shadowPeople { //Loop through each person
            for tow in rockTowers { //Loop through each tower
                if inVicinity(person, tower: tow) { //If there is a person in the range of the tower
                    tow.rotate(person, tower: tow)
                }
            }
            
            for tow in waterTowers {
                if inVicinity(person, tower: tow) {
                    tow.rotate(person, tower: tow)
                }
            }
            
            for tow in airTowers {
                if inVicinity(person, tower: tow) {
                    tow.rotate(person, tower: tow)
                }
            }
            
            for tow in fireTowers {
                if inVicinity(person, tower: tow) {
                    tow.rotate(person, tower: tow)
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
