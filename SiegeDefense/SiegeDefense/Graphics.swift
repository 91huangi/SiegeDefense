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
    
    public static var siegeColor = UIColor.init(red: 102.0/255, green: 82.0/255, blue: 66.0/255, alpha: 1.0)
    public static var flagFrames = [SKTexture]()
    public static var targetMoving = [SKTexture]()
    public static var targetAttacking = [SKTexture]()
    public static var targetReloading = [SKTexture]()
    public static var spearmanMoving = [SKTexture]()
    public static var spearmanAttacking = [SKTexture]()
    public static var spearmanReloading = [SKTexture]()
    public static var knightMoving = [SKTexture]()
    public static var knightAttacking = [SKTexture]()
    public static var knightReloading = [SKTexture]()
    public static var ramMoving = [SKTexture]()
    public static var ramAttacking = [SKTexture]()
    public static var ramReloading = [SKTexture]()
    public static var catapultMoving = [SKTexture]()
    public static var catapultAttacking = [SKTexture]()
    public static var catapultReloading = [SKTexture]()
    
    
    static func loadAnimations() {
        flagFrames.append(SKTexture(imageNamed: "Flag-01"))
        flagFrames.append(SKTexture(imageNamed: "Flag-02"))
        flagFrames.append(SKTexture(imageNamed: "Flag-03"))
        flagFrames.append(SKTexture(imageNamed: "Flag-04"))
        flagFrames.append(SKTexture(imageNamed: "Flag-05"))
        flagFrames.append(SKTexture(imageNamed: "Flag-06"))
        
        
        targetMoving.append(SKTexture(imageNamed: "Target-01"))
        targetAttacking.append(SKTexture(imageNamed: "Target-01"))
        targetReloading.append(SKTexture(imageNamed: "Target-01"))
        
        
        spearmanMoving.append(SKTexture(imageNamed: "Spearman-01"))
        spearmanMoving.append(SKTexture(imageNamed: "Spearman-02"))
        spearmanMoving.append(SKTexture(imageNamed: "Spearman-03"))
        spearmanMoving.append(SKTexture(imageNamed: "Spearman-04"))
        spearmanMoving.append(SKTexture(imageNamed: "Spearman-05"))
        spearmanMoving.append(SKTexture(imageNamed: "Spearman-06"))
        spearmanMoving.append(SKTexture(imageNamed: "Spearman-07"))
        spearmanMoving.append(SKTexture(imageNamed: "Spearman-08"))
        spearmanMoving.append(SKTexture(imageNamed: "Spearman-09"))
        spearmanMoving.append(SKTexture(imageNamed: "Spearman-10"))
        spearmanAttacking.append(SKTexture(imageNamed: "Spearman_Attack-01"))
        spearmanAttacking.append(SKTexture(imageNamed: "Spearman_Attack-02"))
        spearmanAttacking.append(SKTexture(imageNamed: "Spearman_Attack-03"))
        spearmanAttacking.append(SKTexture(imageNamed: "Spearman_Attack-04"))
        spearmanAttacking.append(SKTexture(imageNamed: "Spearman_Attack-05"))
        spearmanReloading.append(SKTexture(imageNamed: "Spearman_Attack-01"))
        
        knightMoving.append(SKTexture(imageNamed: "Knight-01"))
        knightMoving.append(SKTexture(imageNamed: "Knight-02"))
        knightMoving.append(SKTexture(imageNamed: "Knight-03"))
        knightMoving.append(SKTexture(imageNamed: "Knight-04"))
        knightMoving.append(SKTexture(imageNamed: "Knight-05"))
        knightMoving.append(SKTexture(imageNamed: "Knight-06"))
        knightMoving.append(SKTexture(imageNamed: "Knight-07"))
        knightMoving.append(SKTexture(imageNamed: "Knight-08"))
        knightMoving.append(SKTexture(imageNamed: "Knight-09"))
        knightMoving.append(SKTexture(imageNamed: "Knight-10"))
        knightAttacking.append(SKTexture(imageNamed: "Knight_Attack-01"))
        knightAttacking.append(SKTexture(imageNamed: "Knight_Attack-02"))
        knightAttacking.append(SKTexture(imageNamed: "Knight_Attack-03"))
        knightAttacking.append(SKTexture(imageNamed: "Knight_Attack-04"))
        knightAttacking.append(SKTexture(imageNamed: "Knight_Attack-05"))
        knightReloading.append(SKTexture(imageNamed: "Knight_Attack-01"))
        
        ramMoving.append(SKTexture(imageNamed: "Ram-01"))
        ramMoving.append(SKTexture(imageNamed: "Ram-02"))
        ramMoving.append(SKTexture(imageNamed: "Ram-03"))
        ramMoving.append(SKTexture(imageNamed: "Ram-04"))
        ramAttacking.append(SKTexture(imageNamed: "Ram_Attack-01"))
        ramAttacking.append(SKTexture(imageNamed: "Ram_Attack-02"))
        ramAttacking.append(SKTexture(imageNamed: "Ram_Attack-03"))
        ramAttacking.append(SKTexture(imageNamed: "Ram_Attack-04"))
        ramAttacking.append(SKTexture(imageNamed: "Ram_Attack-05"))
        ramAttacking.append(SKTexture(imageNamed: "Ram_Attack-06"))
        ramAttacking.append(SKTexture(imageNamed: "Ram_Attack-07"))
        ramAttacking.append(SKTexture(imageNamed: "Ram_Attack-08"))
        ramAttacking.append(SKTexture(imageNamed: "Ram_Attack-09"))
        ramReloading.append(SKTexture(imageNamed: "Ram_Attack-01"))
        
        
        
        catapultMoving.append(SKTexture(imageNamed: "Catapult-01"))
        catapultMoving.append(SKTexture(imageNamed: "Catapult-02"))
        catapultMoving.append(SKTexture(imageNamed: "Catapult-03"))
        catapultMoving.append(SKTexture(imageNamed: "Catapult-04"))
        catapultAttacking.append(SKTexture(imageNamed: "Catapult_Attack-01"))
        catapultAttacking.append(SKTexture(imageNamed: "Catapult_Attack-02"))
        catapultAttacking.append(SKTexture(imageNamed: "Catapult_Attack-03"))
        catapultAttacking.append(SKTexture(imageNamed: "Catapult_Attack-04"))
        catapultAttacking.append(SKTexture(imageNamed: "Catapult_Attack-05"))
        catapultAttacking.append(SKTexture(imageNamed: "Catapult_Attack-06"))
        catapultAttacking.append(SKTexture(imageNamed: "Catapult_Attack-07"))
        catapultAttacking.append(SKTexture(imageNamed: "Catapult_Attack-08"))
        catapultAttacking.append(SKTexture(imageNamed: "Catapult_Attack-09"))
        catapultAttacking.append(SKTexture(imageNamed: "Catapult_Attack-10"))
        catapultAttacking.append(SKTexture(imageNamed: "Catapult_Attack-11"))
        catapultReloading.append(SKTexture(imageNamed: "Catapult_Reload-01"))
        catapultReloading.append(SKTexture(imageNamed: "Catapult_Reload-02"))
        catapultReloading.append(SKTexture(imageNamed: "Catapult_Reload-03"))
        catapultReloading.append(SKTexture(imageNamed: "Catapult_Reload-04"))
        catapultReloading.append(SKTexture(imageNamed: "Catapult_Reload-05"))
        catapultReloading.append(SKTexture(imageNamed: "Catapult_Reload-06"))
        catapultReloading.append(SKTexture(imageNamed: "Catapult_Reload-07"))
        catapultReloading.append(SKTexture(imageNamed: "Catapult_Reload-08"))
        catapultReloading.append(SKTexture(imageNamed: "Catapult_Reload-09"))
        catapultReloading.append(SKTexture(imageNamed: "Catapult_Reload-10"))
        catapultReloading.append(SKTexture(imageNamed: "Catapult_Reload-11"))

        
    }
}
