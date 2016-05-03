//
//  Path.swift
//  Elemental Tower Defense
//
//  Created by Andrew Turley on 5/2/16.
//  Copyright © 2016 Polturonduken. All rights reserved.
//

import Foundation
import SpriteKit

class Path: Tile {
    var forward : Path!
    var backward : Path!
    
    convenience init() {
        self.init(forward: nil, backward: nil, x: 0, y: 0, img: "")
    }
    
    init(forward: Path?, backward: Path?, x: Int, y: Int, img: String) {
        super.init(xLoc: x, yLoc: y, name: img)
        self.forward = forward
        self.backward = backward
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}