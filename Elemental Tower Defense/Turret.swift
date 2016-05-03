//
//  Turret.swift
//  Elemental Tower Defense
//
//  Created by Andrew Turley on 5/3/16.
//  Copyright © 2016 Polturonduken. All rights reserved.
//

import Foundation
import SpriteKit

class Turret: Tower {
    convenience init() {
        self.init(element: "", range: 0, power: 0, rate: 0, towerType: "", x: 0, y: 0, img: "")
    }
    
    override init(element: String, range: Int, power: Int, rate: Int, towerType: String, x: Int, y: Int, img: String) {
        super.init(element: element, range: range, power: power, rate: rate, towerType: towerType, x: x, y: y, img: img)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}