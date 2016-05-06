//
//  Projectile.swift
//  Elemental Tower Defense
//
//  Created by Andrew Turley on 5/4/16.
//  Copyright © 2016 Polturonduken. All rights reserved.
//

import Foundation
import SpriteKit

class Projectile: SKSpriteNode {
//    override var speed : CGFloat!
    var power : Int!
    var direction : CGVector!
    
    convenience init() {
        self.init(speed: 0, power: 0, direction: CGVector(dx: 0, dy: 0), image: "")
    }
    
    init(speed: CGFloat, power: Int, direction: CGVector, image: String) {
        self.power = power
        self.direction = direction
        let texture = SKTexture(imageNamed: image)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.speed = speed
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}