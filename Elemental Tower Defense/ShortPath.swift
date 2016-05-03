//
//  ShortPath.swift
//  Elemental Tower Defense
//
//  Created by Andrew Turley on 5/3/16.
//  Copyright © 2016 Polturonduken. All rights reserved.
//

import Foundation

class ShortPath {
    var x : Int!
    var y : Int!
    var number : Int!
    
    convenience init() {
        self.init(x: 0, y: 0, number: 0)
    }
    
    init(x: Int, y: Int, number: Int) {
        self.x = x
        self.y = y
        self.number = number
    }
}