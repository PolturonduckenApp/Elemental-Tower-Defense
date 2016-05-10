//
//  Grid.swift
//  Elemental Tower Defense
//
//  Created by Andrew Turley on 3/17/16 && later editied by Philip R. Onffroy.
//  Copyright © 2016 Polturonduken. All rights reserved.
//

import Foundation
import SpriteKit

class Grid {
    var towerList : [[Tile]] = [[]]
    
    convenience init() {
        self.init(towerList: [[]])
    }
    
    init(towerList: [[Tile]]) {
        self.towerList = towerList
        //the dimentions that will be passed in are 6x8, each tile 128 pixes by 128 pixels
    }
}