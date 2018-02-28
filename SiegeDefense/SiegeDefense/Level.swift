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
    
    public var levelNum:Int
    public var timer:Int
    
    init(levelNum: Int) {
        self.levelNum=levelNum
        self.timer=20+levelNum
    }
    

}
