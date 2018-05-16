//
//  Wall.swift
//  SiegeDefense
//
//  Created by Ivan Huang on 2/21/18.
//  Copyright © 2018 Ivan Huang. All rights reserved.
//

import Foundation
import SpriteKit

class Castle:SKSpriteNode {
    var health: Int
    var maxHealth: Int
    var offset: CGFloat
    
    init(health: Int, maxHealth: Int, imageNamed: String) {
        self.health = health
        self.maxHealth = maxHealth
        self.offset = 160
        
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.black, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
