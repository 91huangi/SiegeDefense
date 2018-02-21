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
        case catapult = 3
    }
    
    enum EnemyState:Int {
        case moving = 0
        case attacking = 1
    }
    
    var enemySpeed: CGFloat
    var range: CGFloat
    var health: Int
    var type: EnemyType
    var state: EnemyState
    
    init(type: EnemyType, imageNamed: String) {
        self.type = type
        self.state = .moving
        
        switch (type) {
        case .spearman:
            self.enemySpeed = 40.0
            self.range = 0.0
            self.health = 1
            break
        case .catapult:
            self.enemySpeed = 15.0
            self.range = 650.0
            self.health = 10
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
    
    func animate() {
        var movingTextures = [SKTexture]()
        var attackingTextures = [SKTexture]()
        switch(type) {
        case .spearman:
            movingTextures = Animations.spearmanMoving
            attackingTextures = Animations.spearmanAttacking
            break
        case .catapult:
            movingTextures = Animations.catapultMoving
            attackingTextures = Animations.catapultAttacking
        default:
            break
        }
        switch(state) {
        case .moving:
            self.run(SKAction.repeatForever(SKAction.animate(with: movingTextures, timePerFrame: 0.1, resize: false, restore: true)), withKey: "enemyMoving")
            break
        case .attacking:
            self.run(SKAction.repeatForever(SKAction.animate(with: attackingTextures, timePerFrame: 0.1, resize: false, restore: true)), withKey: "enemyAttacking")
            break
        default:
            break
        }
    }
    
    
}
