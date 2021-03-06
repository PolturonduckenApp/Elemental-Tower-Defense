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
    private var element : String!
    private var range : Int!
    private var power : Int!
    private var towerType : String!
    
    convenience init() {
        self.init(element: "", range: 0, power: 0, towerType: "", x: 0, y: 0, img: "")
    }
    
    init(element: String, range: Int, power: Int, towerType: String, x: Int, y: Int, img: String) {
        super.init(xLoc: x, yLoc: y, name: img)
        self.element = element
        self.range = range
        self.power = power
        self.towerType = towerType
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setElement(element: String) {
        self.element = element
    }
    
    func setRange(range: Int) {
        self.range = range
    }
    
    func setPower(power: Int) {
        self.power = power
    }
    
    func setTowerType(towerType: String) {
        self.towerType = towerType
    }
    
    func getElement() -> String {
        return element
    }
    
    func getRange() -> Int {
        return range
    }
    
    func getPower() -> Int {
        return power
    }
    
    func getTowerType() -> String {
        return towerType
    }
}