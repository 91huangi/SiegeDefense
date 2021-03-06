//
//  Arrow.swift
//  SiegeDefense
//
//  Created by Ivan Huang on 2/26/18.
//  Copyright © 2018 Ivan Huang. All rights reserved.
//

import Foundation
import SpriteKit

class Arrow: SKSpriteNode {
    var userOwned: Bool
    
    init(userOwned: Bool, imageNamed: String) {
        self.userOwned = userOwned
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.black, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
