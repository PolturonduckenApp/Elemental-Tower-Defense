//
//  Grid.swift
//  Elemental Tower Defense
//
//  Created by Andrew Turley on 3/17/16.
//  Copyright © 2016 Polturonduken. All rights reserved.
//

import Foundation
import SpriteKit

class Grid {
    var towerList : [[Bool]] = [[false]]
    var locations : [[CGPoint]]!
    
    convenience init() {
        self.init(locations: [[]])
    }
    
    init(locations: [[CGPoint]]) {
        self.locations = locations
        
        for x in 0..<locations.count {
            self.towerList.append([false])
            for _ in 0..<20 {
                self.towerList[x].append(false)
            }
        }
    }
}