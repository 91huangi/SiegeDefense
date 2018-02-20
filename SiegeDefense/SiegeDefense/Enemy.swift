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
        case spearman = 0
    }
    
    enum EnemyState:Int {
        case moving = 0
    }
    
    var enemySpeed: CGFloat
    var health: Int
    var type: EnemyType
    var state: EnemyState
    
    init(type: EnemyType, imageNamed: String) {
        self.type = type
        self.state = .moving
        
        switch (type) {
        case .spearman:
            self.enemySpeed = 40.0
            self.health = 1
            break
        }
        
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.black, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
