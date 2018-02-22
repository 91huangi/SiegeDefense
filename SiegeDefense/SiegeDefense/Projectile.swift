//
//  Projectile.swift
//  SiegeDefense
//
//  Created by Ivan Huang on 2/21/18.
//  Copyright © 2018 Ivan Huang. All rights reserved.
//

import Foundation
import SpriteKit

class Projectile: SKSpriteNode {
    
    var owner: Enemy
    
    init(owner: Enemy, texture: SKTexture) {
        self.owner = owner
        super.init(texture: texture, color: UIColor.black, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
