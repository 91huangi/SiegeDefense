//
//  Level.swift
//  SiegeDefense
//
//  Created by Ivan Huang on 2/19/18.
//  Copyright © 2018 Ivan Huang. All rights reserved.
//

import Foundation
import SpriteKit

class Level {
    
    public var level:Int
    public var timer:Int
    public var loadOnFrame: Int
    
    init(level: Int, timer: Int) {
        self.level=level
        self.timer=timer
        self.loadOnFrame = 0
    }
    
    enum objectType:UInt32 {
        case none=0
        
        case wall=1
        case arrow=2
        case enemy=4
        case debris = 8
        
        case screenBorder=1024
    }
}
