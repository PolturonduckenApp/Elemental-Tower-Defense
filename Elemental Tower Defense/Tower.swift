//
//  Tower.swift
//  Elemental Tower Defense
//
//  Created by Andrew Turley on 3/16/16.
//  Copyright © 2016 Polturonduken. All rights reserved.
//

import Foundation
import SpriteKit

class Tower: Tile {
    var element : String!
    var range : Int!
    var power : Int!
    var towerType : String!
    var rateOfFire : Int!
    
    convenience init() {
        self.init(element: "", range: 0, power: 0, rate: 0, towerType: "", x: 0, y: 0, img: "")
    }
    
    init(element: String, range: Int, power: Int, rate: Int, towerType: String, x: Int, y: Int, img: String) {
        super.init(xLoc: x, yLoc: y, name: img)
        self.element = element
        self.range = range
        self.power = power
        self.rateOfFire = rate
        self.towerType = towerType
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}