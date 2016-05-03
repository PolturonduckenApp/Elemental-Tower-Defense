//
//  Enemy.swift
//  Elemental Tower Defense
//
//  Created by Andrew Turley on 4/30/16.
//  Copyright © 2016 Polturonduken. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy: Tile {
    private var type : String!
    private var defenseType : String!
    private var health : Int!
//    private var speed : Int!
    
    
    convenience init() {
        self.init(type: "", defenseType: "", health: 0, speed: 0, x: 0, y: 0, imgName: "")
    }
    
    init(type: String, defenseType: String, health: Int, speed: Int, x: Int, y: Int, imgName: String) {
        super.init(xLoc: 0, yLoc: 0, name: imgName)
        self.type = type
        self.defenseType = defenseType
        self.health = health
//        self.speed = speed
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}