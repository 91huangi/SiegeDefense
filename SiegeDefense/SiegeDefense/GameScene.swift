//
//  GameScene.swift
//  SiegeDefense
//
//  Created by Ivan Huang on 2/19/18.
//  Copyright © 2018 Ivan Huang. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var touchLoc = [UITouch: CGPoint]()
    private var utils = Utils()
    
    var arrows = [SKSpriteNode]()
    var enemies = [Enemy]()
    var background = SKSpriteNode()
    var ground = SKSpriteNode()
    
    var level = Level(level: 0, timer: 0)
    
    var frameNumber = 0
    
    let wallX = -350
    let wallOffset=175
    
    let towerPos = CGPoint(x: -550, y: -150)
    
    override func didMove(to view: SKView) {
        
        print("Starting")
        physicsWorld.contactDelegate = self
        
        background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 0, y: 0)
        background.size = CGSize(width: 1334, height: 750)
        background.zPosition = -1
        self.addChild(background)
        
        ground = SKSpriteNode(imageNamed: "ground")
        ground.position = CGPoint(x: 0, y: -350)
        ground.size = CGSize(width: 1334, height: 275)
        ground.zPosition = 0
        self.addChild(ground)
        
        // adding scene border
        let bottomBorder = SKSpriteNode()
        bottomBorder.position = CGPoint(x:0, y:-370)
        bottomBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 4000, height: 2))
        bottomBorder.physicsBody!.pinned=true
        bottomBorder.physicsBody!.categoryBitMask = Level.objectType.screenBorder.rawValue
        bottomBorder.physicsBody!.contactTestBitMask = Level.objectType.arrow.rawValue | Level.objectType.debris.rawValue
        bottomBorder.physicsBody!.collisionBitMask = Level.objectType.none.rawValue
        self.addChild(bottomBorder)
        
        var tower = SKSpriteNode(imageNamed: "tower-0")
        tower.size = CGSize(width: 175, height: 350)
        tower.position = towerPos
        tower.zPosition = 1
        
        var towerFrames = [SKTexture]()
        towerFrames.append(SKTexture(imageNamed: "tower-0"))
        towerFrames.append(SKTexture(imageNamed: "tower-1"))
        towerFrames.append(SKTexture(imageNamed: "tower-2"))
        towerFrames.append(SKTexture(imageNamed: "tower-3"))
        towerFrames.append(SKTexture(imageNamed: "tower-4"))
        towerFrames.append(SKTexture(imageNamed: "tower-5"))
        towerFrames.append(SKTexture(imageNamed: "tower-6"))
        tower.run(SKAction.repeatForever(SKAction.animate(with: towerFrames, timePerFrame: 0.1, resize: false, restore: true)), withKey: "towerAnimation")

        
        self.addChild(tower)
        
        
        var wall = SKSpriteNode(imageNamed: "wall-0")
        wall.size = CGSize(width: 450, height: 350)
        wall.position = CGPoint(x: wallX, y: -200)
        wall.zPosition = 1
        self.addChild(wall)

        Animations.loadAnimations()
        level = Level(level: 1, timer: 100)


    }
    
    func loadEnemy(type: Enemy.EnemyType) {
        
        
        var enemy: Enemy
        
        switch(type) {
        case .spearman:
            enemy = Enemy(type: Enemy.EnemyType.spearman, imageNamed: "spearman-0")
            enemy.size = CGSize(width: 48, height: 48)
            enemy.run(SKAction.colorize(with: UIColor.black, colorBlendFactor: 1.0, duration: 0.0))
            enemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 24, height: 48))

            break
        case .catapult:
            enemy = Enemy(type: Enemy.EnemyType.catapult, imageNamed: "catapult-0")
            
            enemy.size = CGSize(width: 96, height: 72)
            enemy.run(SKAction.colorize(with: UIColor.brown, colorBlendFactor: 1.0, duration: 0.0))
            enemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 96, height: 48))

            break
        }


        enemy.state = .moving
        enemy.animate()
        enemy.position = CGPoint(x: 800, y: -330+CGFloat(arc4random_uniform(100)))
        
        enemy.xScale = -1
        enemy.physicsBody!.categoryBitMask = Level.objectType.enemy.rawValue
        enemy.physicsBody!.contactTestBitMask = Level.objectType.arrow.rawValue
        enemy.physicsBody!.collisionBitMask = Level.objectType.none.rawValue
        enemy.physicsBody!.affectedByGravity = false
        enemy.zPosition = 2
        
        enemies.append(enemy)
        self.addChild(enemy)
    }
    func updateArrows() {
        for arrow in arrows {
            var physBod = arrow.physicsBody!
            arrow.run(SKAction.rotate(toAngle: utils.arctan(r: physBod.velocity.dy/physBod.velocity.dx), duration: 0))
        }
    }
    
    func updateEnemies() {
        for enemy in enemies {
            if(enemy.health <= 0) {
                enemyDead(enemy: enemy)
                continue
            }
            switch(enemy.state) {
            case .moving:
                enemy.physicsBody!.velocity.dx = -enemy.enemySpeed
                if(enemy.position.x - enemy.range <= CGFloat(wallX+wallOffset+Int(enemy.position.y) + 250)) {
                    enemy.state = .attacking
                    enemy.animate()
                }
                break
            case .attacking:
                enemy.physicsBody!.velocity.dx = 0
                break
            default:
                break
            }
        }
    }
    
    func enemyDead(enemy: Enemy) {
        let type = enemy.type
        switch (type) {
        case .spearman:
            bloodAnimation(enemy: enemy)
            break
        default:
            break
        }
        enemy.removeFromParent()
        enemies.remove(at: enemies.index(where: {$0==enemy})!)
    }
    
    func bloodAnimation(enemy: Enemy) {
        for _ in 1...15 {
            let randAngle = Double(arc4random_uniform(UInt32(utils.pi)))-Double(utils.pi/2)
            let pixel = SKSpriteNode()
            pixel.color = UIColor.red
            pixel.size = CGSize(width: 3.0, height: 3.0)
            pixel.position = enemy.position
            pixel.zPosition = 1
            pixel.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 3, height: 3))
            pixel.physicsBody!.affectedByGravity = true
            pixel.physicsBody!.mass = 0.1
            
            pixel.physicsBody!.categoryBitMask = Level.objectType.debris.rawValue
            pixel.physicsBody!.contactTestBitMask = Level.objectType.screenBorder.rawValue
            pixel.physicsBody!.collisionBitMask = Level.objectType.none.rawValue

            
            self.addChild(pixel)
            
            pixel.physicsBody!.applyImpulse(CGVector(dx: 20*cos(randAngle), dy: 20*sin(randAngle)))
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            touchLoc[t]=location
        }
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location=t.location(in:self)
            let startLoc = touchLoc[t]!
            if(utils.distance(p1: location, p2: startLoc) >= 25 && startLoc.x > location.x) {
                let power = min(utils.distance(p1: location, p2: startLoc), 500)
                let angle = utils.arctan(r: (startLoc.y-location.y)/(startLoc.x-location.x))
                var arrow = SKSpriteNode(imageNamed: "arrow")
                arrow.size = CGSize(width: 30, height: 3)
                arrow.run(SKAction.colorize(with: UIColor.black, colorBlendFactor: 1.0, duration: 0.0))
                arrow.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 3))
                arrow.position = CGPoint(x: towerPos.x, y: towerPos.y+50)
                arrow.physicsBody!.velocity.dx = 3*power*cos(angle)
                arrow.physicsBody!.velocity.dy = 3*power*sin(angle)
                arrow.physicsBody!.affectedByGravity=true
                arrow.physicsBody!.allowsRotation = true
                arrow.physicsBody!.categoryBitMask = Level.objectType.arrow.rawValue
                arrow.physicsBody!.contactTestBitMask = Level.objectType.enemy.rawValue | Level.objectType.screenBorder.rawValue
                arrow.physicsBody!.collisionBitMask = Level.objectType.none.rawValue
                arrow.zPosition = 1
                arrows.append(arrow)
                self.addChild(arrow)
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let categoryMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        

        switch(categoryMask) {
        case Level.objectType.arrow.rawValue | Level.objectType.enemy.rawValue:
            if(contact.bodyA.categoryBitMask == Level.objectType.arrow.rawValue) {
                contact.bodyA.node?.removeFromParent()
            } else {
                contact.bodyB.node?.removeFromParent()
            }
            arrows.remove(at: arrows.index(where: {$0==contact.bodyA.node || $0==contact.bodyB.node})!)
            enemies[enemies.index(where: {$0==contact.bodyA.node || $0==contact.bodyB.node})!].health -= 1
            break
        case Level.objectType.arrow.rawValue | Level.objectType.screenBorder.rawValue:
            if(contact.bodyA.categoryBitMask == Level.objectType.arrow.rawValue) {
                contact.bodyA.node?.removeFromParent()
            } else {
                contact.bodyB.node?.removeFromParent()
            }
            arrows.remove(at: arrows.index(where: {$0==contact.bodyA.node || $0==contact.bodyB.node})!)
            break
        case Level.objectType.debris.rawValue | Level.objectType.screenBorder.rawValue:
            if(contact.bodyA.categoryBitMask == Level.objectType.debris.rawValue) {
                contact.bodyA.node?.removeFromParent()
            } else {
                contact.bodyB.node?.removeFromParent()
            }
            break
        default:
            break
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        updateArrows()
        updateEnemies()
        
        frameNumber += 1
        
        if(frameNumber % 60 == 0) {
            level.timer -= 1;
        }
        
        if(level.timer % 5 == 0 && frameNumber % 60 == 0) {
            loadEnemy(type: .catapult)
        }
    }
}
