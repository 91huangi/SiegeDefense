//
//  Enemy.swift
//  SiegeDefense
//
//  Created by Ivan Huang on 2/19/18.
//  Copyright © 2018 Ivan Huang. All rights reserved.
//

import Foundation
import SpriteKit


class Enemy:SKSpriteNode{
    
    enum EnemyType:Int {
        case target = 0
        case spearman = 1
        case knight = 3
        case ram = 4
        case catapult = 5
    }
    
    enum EnemyState:Int {
        case moving = 0
        case attacking = 1
        case reloading = 2
    }
    
    var enemySpeed: CGFloat
    var attack: CGFloat
    var range: CGFloat
    var health: CGFloat
    var type: EnemyType
    var timer: CGFloat
    var attackTimer: CGFloat
    var reloadTimer: CGFloat
    var state: EnemyState

    
    init(type: EnemyType, imageNamed: String) {
        self.type = type
        self.state = .moving
        
        switch (type) {
        case .target:
            self.enemySpeed = 0.0
            self.range = 0.0
            self.health = 1
            self.timer = 0.0
            self.attackTimer = 0.0
            self.reloadTimer = 0.0
            self.attack = 0.0
            break
        case .spearman:
            self.enemySpeed = 60.0
            self.range = 0.0
            self.health = 1
            self.timer = 0.0
            self.attackTimer = 5.0
            self.reloadTimer = 0.0
            self.attack = 1.0
            break
        case .knight:
            self.enemySpeed = 40.0
            self.range = 0.0
            self.health = 2
            self.timer = 0.0
            self.attackTimer = 5.0
            self.reloadTimer = 0.0
            self.attack = 2.0
            break
        case .ram:
            self.enemySpeed = 25.0
            self.range = 0.0
            self.health = 20
            self.timer = 0.0
            self.attackTimer = 10.0
            self.reloadTimer = 0.0
            self.attack = 8.0
            break
        case .catapult:
            self.enemySpeed = 25.0
            self.range = 700.0
            self.health = 15
            self.timer = 0.0
            self.attackTimer = 10.0
            self.reloadTimer = 30.0
            self.attack = 15.0
            break
        }
        
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.black, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
