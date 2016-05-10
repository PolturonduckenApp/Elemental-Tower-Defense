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
    var tileX : Int!
    var tileY: Int!
//    var image : SKSpriteNode!
    //tileX will be between 0-8 and tileY 0-6
    
    convenience init() {
        self.init(tileX: 0, tileY: 0, name: "")
    }
    
    init(tileX: Int, tileY: Int, name: String) {
        let texture = SKTexture(imageNamed: name)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.tileX = tileX
        self.tileY = tileY
//        self.image = image
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func convertWholeTile(pos: CGPoint)
    {
        
    }
    
}
