//
//  Tile.swift
//  Elemental Tower Defense
//
//  Created by Andrew Turley on 5/2/16.
//  Copyright © 2016 Polturonduken. All rights reserved.
//

import Foundation
import SpriteKit

class Tile: SKSpriteNode {
    var xLoc : Int!
    var yLoc : Int!
//    var image : SKSpriteNode!
    
    convenience init() {
        self.init(xLoc: 0, yLoc: 0, name: "")
    }
    
    init(xLoc: Int, yLoc: Int, name: String) {
        let texture = SKTexture(imageNamed: name)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.xLoc = xLoc
        self.yLoc = yLoc
//        self.image = image
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}