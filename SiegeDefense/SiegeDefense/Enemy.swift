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
        case spearman = 3
        case knight = 5
        case catapult = 8
    }
    
    enum EnemyState:Int {
        case moving = 0
        case attacking = 1
        case reloading = 2
    }
    
    var enemySpeed: CGFloat
    var attack: CGFloat
    var range: CGFloat
    var health: Int
    var type: EnemyType
    var timer: CGFloat
    var attackTimer: CGFloat
    var reloadTimer: CGFloat
    var state: EnemyState

    
    init(type: EnemyType, imageNamed: String) {
        self.type = type
        self.state = .moving
        
        switch (type) {
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
        case .catapult:
            self.enemySpeed = 30.0
            self.range = 650.0
            self.health = 10
            self.timer = 0.0
            self.attackTimer = 10.0
            self.reloadTimer = 20.0
            self.attack = 10.0
            break
        default:
            break
        }
        
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.black, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
