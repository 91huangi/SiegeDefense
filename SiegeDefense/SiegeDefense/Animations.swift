//
//  Animations.swift
//  SiegeDefense
//
//  Created by Ivan Huang on 2/20/18.
//  Copyright © 2018 Ivan Huang. All rights reserved.
//

import Foundation
import SpriteKit

class Animations {
    public static var spearmanMoving = [SKTexture]()
    public static var spearmanAttacking = [SKTexture]()
    
    static func loadAnimations() {
        spearmanMoving.append(SKTexture(imageNamed: "spearman-0"))
        spearmanMoving.append(SKTexture(imageNamed: "spearman-1"))
        spearmanMoving.append(SKTexture(imageNamed: "spearman-2"))
        spearmanMoving.append(SKTexture(imageNamed: "spearman-3"))
        spearmanMoving.append(SKTexture(imageNamed: "spearman-4"))
        spearmanMoving.append(SKTexture(imageNamed: "spearman-5"))
        spearmanMoving.append(SKTexture(imageNamed: "spearman-6"))
        spearmanMoving.append(SKTexture(imageNamed: "spearman-7"))
        spearmanMoving.append(SKTexture(imageNamed: "spearman-8"))
        spearmanMoving.append(SKTexture(imageNamed: "spearman-9"))
        
        spearmanAttacking.append(SKTexture(imageNamed: "spearman-10"))
        spearmanAttacking.append(SKTexture(imageNamed: "spearman-11"))
        spearmanAttacking.append(SKTexture(imageNamed: "spearman-12"))
        spearmanAttacking.append(SKTexture(imageNamed: "spearman-13"))
        spearmanAttacking.append(SKTexture(imageNamed: "spearman-14"))
        spearmanAttacking.append(SKTexture(imageNamed: "spearman-15"))
        
        
    }
}
