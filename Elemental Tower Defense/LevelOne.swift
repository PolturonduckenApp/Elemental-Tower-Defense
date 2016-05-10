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
        
        var locations : [[Tile]] = [[]] //Locations of towers
        
        //Attempts to determine distance between tiles
        widthSep = Double(screenWidth / 8)
        heightSep = Double(screenHeight / 6)
        
        //Sets up grid
        for x in 0..<8 {
            locations.append([Tile(tileX: -1, tileY: -1, name: "remove")])
            for y in 0..<6 {
                locations[x].append(Tile(tileX: x, tileY: y, name: "AirClipArt")) //name to be changed
            }
        }
        
        for x in 0..<8 {
            locations[x].removeAtIndex(0)
        }
        
        grid = Grid(towerList: locations) //Sets up grid pt. 2
        
        shortPath.append(ShortPath(x: 0, y: 3, number: 3))
        shortPath.append(ShortPath(x: 4, y: 4, number: 1))
        shortPath.append(ShortPath(x: 4, y: 5, number: 4))
        
        setUpPath(shortPath)
        
        //Level One Title
        let levelOneLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelOneLabel.text = "Level One"
        levelOneLabel.name = "Level Label"
        levelOneLabel.fontSize = 45
        levelOneLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) + 300)
        
        /**
        * Sets up icons V2
        * fix separation to make them span accross the whole screen
        */
        let mainRock = Tile(tileX: 0, tileY: 0, name: "Main Rock'")
        grid.towerList[0][0] = mainRock
        mainRock.position.x = 64 //may not need this but leaving it for now
        mainRock.position.y = 64
        mainRock.xScale = 0.1
        mainRock.yScale = 0.1

        let mainWater = Tile(tileX: 0, tileY: 0, name: "Main Water'")
        grid.towerList[2][0] = mainWater
        mainWater.position.x = 192
        mainWater.position.y = 64
        
        let mainAir = Tile(tileX: 0, tileY: 0, name: "Main Air'")
        grid.towerList[4][0] = mainAir
        mainAir.position.x = 320
        mainAir.position.y = 64
        
        let mainFire = Tile(tileX: 0, tileY: 0, name: "Main Fire'")
        grid.towerList[6][0] = mainRock
        mainFire.position.x = 448
        mainFire.position.y = 64
        
        self.addChild(mainRock)
        self.addChild(mainAir)
        self.addChild(mainWater)
        self.addChild(mainFire)
        self.addChild(levelOneLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)//Find the location of the touch
            print(touch.locationInNode(self).x)
            
            /**
             * • Determines which tower
             * • Creates a new tower and adds it to the list
             * • Sets up other necessary variables
             */
            print(self.nodeAtPoint(location).name)
            if self.nodeAtPoint(location).name == "Main Rock" {
                let newTower = Tower(element: "Rock", range: 100, power: 10, rate: 10, towerType: "turret", x:0 , y: 0, img: "Rock")//0 ≤ x ≤ 8, 0 ≤ y ≤ 6
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
                let newTower = Tower(element: "Water", range: 100, power: 10, rate: 10, towerType: "turret", x: 0, y: 0, img: "Water")
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
                        curTowerIndex = waterTowers.indexOf(self.nodeAtPoint(location) as! Tower)!
                    }
                    else if curTowerType == "Air" {
                        curTowerIndex = airTowers.indexOf(self.nodeAtPoint(location) as! Tower)!
                    }
                    else if curTowerType == "Fire" {
                        curTowerIndex = fireTowers.indexOf(self.nodeAtPoint(location) as! Tower)!
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
       
                /**
                 * So as far as I can tell this is what this does:
                 * • Determines type of the new Tower type
                 * • Determines if there is an open space where the tower is dropped
                 * • If there is an open space, break from search, signal a found open space, put the tower there
                 * So I symplified this to check if the tile the tower is touching is occupied or not, still in testing mode
                 */
                if curTowerType == "Rock" {
                    if grid.towerList[Int(rockTowers[curTowerIndex].position.x) / Int(widthSep)][Int(rockTowers[curTowerIndex].position.y) / Int(heightSep)].name == "AirClipArt" { //eventually change away from AirClipArt
                        grid.towerList[Int(rockTowers[curTowerIndex].position.x) / Int(widthSep)][Int(rockTowers[curTowerIndex].position.y) / Int(heightSep)] = rockTowers[curTowerIndex]
                        breakFromSearch = true
                        foundOpenSpace = true
                    }
                }
                else if curTowerType == "Air" {
                    if grid.towerList[Int(airTowers[curTowerIndex].position.x) / Int(widthSep)][Int(airTowers[curTowerIndex].position.y) / Int(heightSep)].name == "AirClipArt" {
                        grid.towerList[Int(airTowers[curTowerIndex].position.x) / Int(widthSep)][Int(airTowers[curTowerIndex].position.y) / Int(heightSep)] = airTowers[curTowerIndex]
                        breakFromSearch = true
                        foundOpenSpace = true

                    }
                }
                else if curTowerType == "Water" {
                    if grid.towerList[Int(waterTowers[curTowerIndex].position.x) / Int(widthSep)][Int(waterTowers[curTowerIndex].position.y) / Int(heightSep)].name == "AirClipArt" {
                        grid.towerList[Int(waterTowers[curTowerIndex].position.x) / Int(widthSep)][Int(waterTowers[curTowerIndex].position.y) / Int(heightSep)] = waterTowers[curTowerIndex]
                        breakFromSearch = true
                        foundOpenSpace = true

                    }
                }
                else if curTowerType == "Fire" {
                    if grid.towerList[Int(fireTowers[curTowerIndex].position.x) / Int(widthSep)][Int(fireTowers[curTowerIndex].position.y) / Int(heightSep)].name == "AirClipArt" {
                        grid.towerList[Int(fireTowers[curTowerIndex].position.x) / Int(widthSep)][Int(fireTowers[curTowerIndex].position.y) / Int(heightSep)] = fireTowers[curTowerIndex]
                        breakFromSearch = true
                        foundOpenSpace = true

                    }
                
        
            if breakFromSearch == true {
                breakFromSearch = false
                
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
                let newPerson = Enemy(type: "Enemy", defenseType: "Enemy", health: 100, speed: 10, gridX: 0, gridY: 4, x: Int(grid.towerList[0][4].tileX), y: Int(grid.towerList[0][4].tileY), imgName: "ShadowPerson")
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
                        if paths.tileX == person.gridX && paths.tileY == person.gridY && paths.forward != nil {
                            person.gridX = paths.forward.tileX
                            person.gridY = paths.forward.tileY
                            person.position = grid.towerList[person.gridX][person.gridY].position
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
                        let projectile = Projectile(speed: 100, power: 100, direction: CGVector(dx: person.position.x - CGFloat(tow.tileX), dy: person.position.y - CGFloat(tow.tileY)), image: "Taco!!")
                        projectile.position.x = 0
                        projectile.position.y = 0
                        projectiles.append(projectile)
                        self.addChild(projectile)
                    }
                }
                
                for tow in waterTowers {
                    if inVicinity(person, tower: tow) {
                        person.health = person.health - 50
                        let projectile = Projectile(speed: 1, power: 100, direction: CGVector(dx: (person.position.x - CGFloat(tow.tileX)) / 20, dy: (person.position.y - CGFloat(tow.tileY)) / 20), image: "Spaceship")
                        projectile.position.x = 0
                        projectile.position.y = 0
                        projectiles.append(projectile)
                        self.addChild(projectile)
                    }
                }
                
                for tow in airTowers {
                    if inVicinity(person, tower: tow) {
                        person.health = person.health - 50
                        let projectile = Projectile(speed: 100, power: 100, direction: CGVector(dx: person.position.x - CGFloat(tow.tileX), dy: person.position.y - CGFloat(tow.tileY)), image: "Spaceship")
                        projectile.position.x = 0
                        projectile.position.y = 0
                        projectiles.append(projectile)
                        self.addChild(projectile)
                    }
                }
                
                for tow in fireTowers {
                    if inVicinity(person, tower: tow) {
                        person.health = person.health - 50
                        let projectile = Projectile(speed: 100, power: 100, direction: CGVector(dx: person.position.x - CGFloat(tow.tileX), dy: person.position.y - CGFloat(tow.tileY)), image: "Spaceship")
                        projectile.position.x = 0
                        projectile.position.y = 0
                        projectiles.append(projectile)
                        self.addChild(projectile)
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
            for x in 0..<grid!.towerList.count {
                for y in 0..<grid!.towerList[x].count {
                    //If the tower is near an open space.....
                    if Double(rockTowers[curTowerIndex].position.x) - widthSep <= Double(grid!.towerList[x][y].tileX) && Double(rockTowers[curTowerIndex].position.x) + widthSep >= Double(grid!.towerList[x][y].tileX) && Double(rockTowers[curTowerIndex].position.y) - widthSep <= Double(grid!.towerList[x][y].tileY) && Double(rockTowers[curTowerIndex].position.y) + widthSep >= Double(grid!.towerList[x][y].tileY) && grid!.towerList[x][y] == false {
                        let temp = disBetweenPoints(rockTowers[curTowerIndex].position, target: grid!.towerList[x][y].position) //....finds difference between the two points....
                        
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
            for x in 0..<grid!.towerList.count {
                for y in 0..<grid!.towerList[x].count {
                    //If the tower is near an open space.....
                    if Double(waterTowers[curTowerIndex].position.x) - widthSep <= Double(grid!.towerList[x][y].tileX) && Double(waterTowers[curTowerIndex].position.x) + widthSep >= Double(grid!.towerList[x][y].tileX) && Double(waterTowers[curTowerIndex].position.y) - widthSep <= Double(grid!.towerList[x][y].tileY) && Double(waterTowers[curTowerIndex].position.y) + widthSep >= Double(grid!.towerList[x][y].tileY) && grid!.towerList[x][y] == false {
                        let temp = disBetweenPoints(waterTowers[curTowerIndex].position, target: grid!.towerList[x][y].position) //....finds difference between the two points....
                        
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
            for x in 0..<grid!.towerList.count {
                for y in 0..<grid!.towerList[x].count {
                    //If the tower is near an open space.....
                    if Double(airTowers[curTowerIndex].position.x) - widthSep <= Double(grid!.towerList[x][y].tileX) && Double(airTowers[curTowerIndex].position.x) + widthSep >= Double(grid!.towerList[x][y].tileX) && Double(airTowers[curTowerIndex].position.y) - widthSep <= Double(grid!.towerList[x][y].tileY) && Double(airTowers[curTowerIndex].position.y) + widthSep >= Double(grid!.towerList[x][y].tileY) && grid!.towerList[x][y] == false {
                        let temp = disBetweenPoints(airTowers[curTowerIndex].position, target: grid!.towerList[x][y].position) //....finds difference between the two points....
                        
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
            for x in 0..<grid!.towerList.count {
                for y in 0..<grid!.towerList[x].count {
                    //If the tower is near an open space.....
                    if Double(fireTowers[curTowerIndex].position.x) - widthSep <= Double(grid!.towerList[x][y].tileX) && Double(fireTowers[curTowerIndex].position.x) + widthSep >= Double(grid!.towerList[x][y].tileX) && Double(fireTowers[curTowerIndex].position.y) - widthSep <= Double(grid!.towerList[x][y].tileY) && Double(fireTowers[curTowerIndex].position.y) + widthSep >= Double(grid!.towerList[x][y].tileY) && grid!.towerList[x][y] == false {
                        let temp = disBetweenPoints(fireTowers[curTowerIndex].position, target: grid!.towerList[x][y].position) //....finds difference between the two points....
                        
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
                let newPath = Path(forward: nil, backward: nil, x: point.x + index, y: point.y, img: "AirClipArt")
                //grid.towerList[point.x + index][point.y] = newPath
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
            print(paths.tileY)
            paths.position = grid.towerList[paths.tileX][paths.tileY].position
            paths.xScale = 0.3
            paths.yScale = 0.3
            paths.zPosition = -10
        }
    }
}
