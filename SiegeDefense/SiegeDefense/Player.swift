//
//  Player.swift
//  SiegeDefense
//
//  Created by Ivan Huang on 2/27/18.
//  Copyright © 2018 Ivan Huang. All rights reserved.
//

import Foundation

class Player {
    static var player: Player = Player()
    
    var score:Int
    var gold:Int
    var bodkinArrow: Bool
    var splitShot: Bool
    var archers: Int
    var archeryRange: Bool
    var levelNum: Int
    var wallHealth: Int
    var wallMaxHealth: Int
    
    init() {
        self.levelNum = 1
        self.score = 0
        self.gold = 0
        self.bodkinArrow = false
        self.splitShot = false
        self.archers = 0
        self.archeryRange = false
        self.wallHealth = 100
        self.wallMaxHealth = 100
    }
    
}
