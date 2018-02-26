//
//  Animations.swift
//  SiegeDefense
//
//  Created by Ivan Huang on 2/20/18.
//  Copyright © 2018 Ivan Huang. All rights reserved.
//

import Foundation
import SpriteKit

class Graphics {
    
    public static var catapultColor = UIColor(red: 40.0/256, green: 26.0/256, blue: 13.0/256, alpha: 1.0)
    public static var skyBlue = UIColor(red: 0.1, green: 0.58, blue: 0.80, alpha: 1.0)
    
    public static var towerFrames = [SKTexture]()
    public static var spearmanMoving = [SKTexture]()
    public static var spearmanAttacking = [SKTexture]()
    public static var spearmanReloading = [SKTexture]()
    public static var catapultMoving = [SKTexture]()
    public static var catapultAttacking = [SKTexture]()
    public static var catapultReloading = [SKTexture]()
    
    static func loadAnimations() {
        towerFrames.append(SKTexture(imageNamed: "tower-0"))
        towerFrames.append(SKTexture(imageNamed: "tower-1"))
        towerFrames.append(SKTexture(imageNamed: "tower-2"))
        towerFrames.append(SKTexture(imageNamed: "tower-3"))
        towerFrames.append(SKTexture(imageNamed: "tower-4"))
        towerFrames.append(SKTexture(imageNamed: "tower-5"))
        towerFrames.append(SKTexture(imageNamed: "tower-6"))
        
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
        
        spearmanReloading.append(SKTexture(imageNamed: "spearman-10"))
        
        catapultMoving.append(SKTexture(imageNamed: "catapult-0"))
        catapultMoving.append(SKTexture(imageNamed: "catapult-1"))
        catapultMoving.append(SKTexture(imageNamed: "catapult-2"))
        catapultMoving.append(SKTexture(imageNamed: "catapult-3"))
        catapultMoving.append(SKTexture(imageNamed: "catapult-4"))
        catapultMoving.append(SKTexture(imageNamed: "catapult-5"))
        
        catapultAttacking.append(SKTexture(imageNamed: "catapult-6"))
        catapultAttacking.append(SKTexture(imageNamed: "catapult-7"))
        catapultAttacking.append(SKTexture(imageNamed: "catapult-8"))
        catapultAttacking.append(SKTexture(imageNamed: "catapult-9"))
        catapultAttacking.append(SKTexture(imageNamed: "catapult-10"))
        
        catapultReloading.append(SKTexture(imageNamed: "catapult-11"))
        catapultReloading.append(SKTexture(imageNamed: "catapult-12"))
        catapultReloading.append(SKTexture(imageNamed: "catapult-13"))
        catapultReloading.append(SKTexture(imageNamed: "catapult-14"))
        catapultReloading.append(SKTexture(imageNamed: "catapult-15"))
        catapultReloading.append(SKTexture(imageNamed: "catapult-16"))
        catapultReloading.append(SKTexture(imageNamed: "catapult-17"))
        
    }
}