//
//  GameScene.swift
//  SiegeDefense
//
//  Created by Ivan Huang on 2/19/18.
//  Copyright © 2018 Ivan Huang. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol GameSceneDelegate: class {
    weak var player: Player? { get set }
    func levelEnded()
}

enum objectType:UInt32 {
    case none=0
    
    case wall=1
    case arrow=2
    case enemy=4
    case debris = 8
    
    case screenBorder=1024
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    weak var gsDel: GameSceneDelegate?
    
    
    var player: Player = Player()
    
    var touchLoc: [UITouch: CGPoint] = [:]
    var frameNumber: Int = 0

    
    var utils: Utils = Utils()
    
    var arrows: [Arrow] = []
    var enemies: [Enemy] = []
    var projectiles: [Projectile] = []
    
    var clouds:[SKSpriteNode] = []
    var wall: Wall = Wall(health: 1, maxHealth: 1, imageNamed: "wall-0")
    var tower: SKSpriteNode = SKSpriteNode()
    var ground: SKSpriteNode = SKSpriteNode()
    
    var towerBottom: CGFloat = 0.0
    var heatedShot: Bool = false
    var splitShot: Bool = false
    var archers: Int = 0
    
    var healthLabel: SKLabelNode = SKLabelNode()
    var levelLabel: SKLabelNode = SKLabelNode()
    var level: Level = Level(levelNum: -1)
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        self.scene?.backgroundColor = Graphics.skyBlue
        Graphics.loadAnimations()
        
        level = Level(levelNum: player.levelNum)


        ground = SKSpriteNode(imageNamed: "ground")
        ground.position = CGPoint(x: 0, y: -280)
        ground.size = CGSize(width: 1334, height: 190)
        ground.zPosition = 0
        self.addChild(ground)
        
        // adding scene border
        let bottomBorder = SKSpriteNode()
        bottomBorder.position = CGPoint(x:0, y:-370)
        bottomBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10000, height: 2))
        bottomBorder.physicsBody!.pinned=true
        bottomBorder.physicsBody!.categoryBitMask = objectType.screenBorder.rawValue
        bottomBorder.physicsBody!.contactTestBitMask = objectType.arrow.rawValue | objectType.debris.rawValue
        bottomBorder.physicsBody!.collisionBitMask = objectType.none.rawValue
        self.addChild(bottomBorder)
        
        // loading tower
        tower = SKSpriteNode(imageNamed: "tower-0")
        tower.size = CGSize(width: 175, height: 350)
        tower.position = CGPoint(x: -550, y: -125)
        tower.zPosition = 3
        tower.run(SKAction.repeatForever(SKAction.animate(with: Graphics.towerFrames, timePerFrame: 0.1, resize: false, restore: true)), withKey: "towerAnimation")
        self.addChild(tower)
        
        towerBottom = tower.position.y-CGFloat(0.5)*tower.size.height
        
        // loading wall
        wall = Wall(health: 100, maxHealth: 100, imageNamed: "wall-0")
        wall.size = CGSize(width: 473, height: 350)
        wall.position = CGPoint(x: -325, y: -200)
        wall.zPosition = 1
        self.addChild(wall)

        // loading labels
        healthLabel.position = CGPoint(x: -550, y: 325)
        healthLabel.fontColor = UIColor.black
        healthLabel.fontName = "Arial Bold"
        self.addChild(healthLabel)
        
        levelLabel.position = CGPoint(x: 0, y: 325)
        levelLabel.fontColor = UIColor.black
        levelLabel.fontName = "Arial Bold"
        levelLabel.text = "Level "+String(level.levelNum)
        self.addChild(levelLabel)
        
        
        let numClouds = arc4random_uniform(3)+2
        
        for _ in 0...numClouds {
            loadCloud(newCloud: false)
        }
        
        



    }
    
    
    func loadCloud(newCloud: Bool) {
        let cloudIndex = Int(arc4random_uniform(6))
        let cloud = SKSpriteNode(texture: Graphics.clouds[cloudIndex])
        cloud.zPosition = -1
        if(newCloud) {
            cloud.position.x = -256 - 667
        } else {
            cloud.position.x = CGFloat(Int(arc4random_uniform(1334)) - 667)
        }
        cloud.position.y = CGFloat(Int(arc4random_uniform(250))+100)
        cloud.run(SKAction.fadeAlpha(to: CGFloat(0.1)*CGFloat(Int(arc4random_uniform(3)) + 2), duration: 0.0))
        cloud.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 512, height: 256))
        cloud.physicsBody!.velocity.dx = CGFloat(Int(arc4random_uniform(30)) + 10)
        cloud.physicsBody!.mass = 0.0
        cloud.physicsBody!.linearDamping = 0.0
        cloud.physicsBody!.friction = 0.0
        cloud.physicsBody!.affectedByGravity = false
        cloud.physicsBody!.categoryBitMask = objectType.none.rawValue
        cloud.physicsBody!.collisionBitMask = objectType.none.rawValue
        clouds.append(cloud)
        self.addChild(cloud)
    }
    
    func loadEnemy(type: Enemy.EnemyType) {
        
        
        var enemy: Enemy
        
        switch(type) {
        case .spearman:
            enemy = Enemy(type: Enemy.EnemyType.spearman, imageNamed: "spearman-0")
            enemy.size = CGSize(width: 48, height: 48)
            enemy.run(SKAction.colorize(with: Graphics.spearmanColor, colorBlendFactor: 1.0, duration: 0.0))
            enemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 24, height: 48))

            break
        case .knight:
            enemy = Enemy(type: Enemy.EnemyType.knight, imageNamed: "knight-0")
            enemy.size = CGSize(width: 60, height: 60)
            // enemy.run(SKAction.colorize(with: Graphics.knightColor, colorBlendFactor: 1.0, duration: 0.0))
            enemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 26, height: 50))
            break
            
        case .catapult:
            enemy = Enemy(type: Enemy.EnemyType.catapult, imageNamed: "catapult-0")
            
            enemy.size = CGSize(width: 96, height: 84)
            enemy.run(SKAction.colorize(with: Graphics.catapultColor, colorBlendFactor: 1.0, duration: 0.0))
            enemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 96, height: 36))

            break
        }


        enemy.state = .moving
        animateEnemy(enemy: enemy)
        enemy.position = CGPoint(x: 750+CGFloat(arc4random_uniform(15)), y: towerBottom+CGFloat(Int(arc4random_uniform(100)) - 25))
        
        enemy.xScale = -1
        enemy.physicsBody!.categoryBitMask = objectType.enemy.rawValue
        enemy.physicsBody!.contactTestBitMask = objectType.arrow.rawValue
        enemy.physicsBody!.collisionBitMask = objectType.none.rawValue
        enemy.physicsBody!.affectedByGravity = false
        
        if(enemy.position.y - CGFloat(0.5)*enemy.size.height >= towerBottom) {
            enemy.zPosition = 2
        } else {
            enemy.zPosition = 4
        }
        
        enemies.append(enemy)
        self.addChild(enemy)
    }
    
    
    func loadArrow(power: CGFloat, angle: CGFloat, heatedShot: Bool) {
        var arrow = Arrow(heatedShot: heatedShot, imageNamed: "arrow")
        arrow.size = CGSize(width: 30, height: 3)
        if(arrow.heatedShot) {
            arrow.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.0))
        } else {
            arrow.run(SKAction.colorize(with: UIColor.black, colorBlendFactor: 1.0, duration: 0.0))
        }
        arrow.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 3))
        arrow.position = CGPoint(x: tower.position.x, y: tower.position.y+50)
        arrow.physicsBody!.velocity.dx = 3*power*cos(angle)
        arrow.physicsBody!.velocity.dy = 3*power*sin(angle)
        arrow.physicsBody!.affectedByGravity=true
        arrow.physicsBody!.allowsRotation = true
        arrow.physicsBody!.categoryBitMask = objectType.arrow.rawValue
        arrow.physicsBody!.contactTestBitMask = objectType.enemy.rawValue | objectType.screenBorder.rawValue
        arrow.physicsBody!.collisionBitMask = objectType.none.rawValue
        arrow.zPosition = 4
        arrows.append(arrow)
        self.addChild(arrow)
    }
    
    func loadProjectile(owner: Enemy) {
        
        
        let rock = SKShapeNode(circleOfRadius: 6.0)
        rock.lineWidth = 0.0
        rock.fillColor = UIColor.black
        let rockTexture = view?.texture(from: rock)
        
        var projectile = Projectile(owner: owner, texture: rockTexture!)

        projectile.position = owner.position
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: 6.0)
        projectile.physicsBody?.pinned = false
        projectile.physicsBody?.affectedByGravity = true
        projectile.physicsBody?.velocity = CGVector(dx: -1200, dy: 500)
        projectile.physicsBody?.collisionBitMask = objectType.none.rawValue
        projectile.zPosition = 3
        
        
        projectiles.append(projectile)

        self.addChild(projectile)
    }
    
    
    
    func updateProjectiles() {
        for projectile in projectiles {
            if(projectile.position.x <= CGFloat(wall.position.x) ) {
                wall.health -= Int(projectile.owner.attack)
                projectile.removeFromParent()
                projectiles.remove(at: projectiles.index(where: {$0==projectile})!)
            }
        }
    }
    
    
    func updateArrows() {
        for arrow in arrows {
            var physBod = arrow.physicsBody!
            arrow.run(SKAction.rotate(toAngle: utils.arctan(opp: physBod.velocity.dy, adj: physBod.velocity.dx), duration: 0))
        }
    }
    
    func updateEnemies() {
        for enemy in enemies {
            if(enemy.health <= 0) {
                enemy.removeFromParent()
                enemies.remove(at: enemies.index(where: {$0==enemy})!)
                continue
            }
            if(enemy.position.x+CGFloat(0.5)*enemy.size.width < -667.0) {
                print("game over")
                exit(0)
            }
            switch(enemy.state) {
            case .moving:
                enemy.physicsBody!.velocity.dx = -enemy.enemySpeed
                if(wall.health > 0 && (enemy.position.x - enemy.range <= wall.position.x+wall.offset-(ground.position.y-enemy.position.y))) {
                    enemy.state = .attacking
                    animateEnemy(enemy: enemy)
                }
                break
            case .attacking:
                enemy.physicsBody!.velocity.dx = 0
                if(enemy.timer < enemy.attackTimer) {
                    enemy.timer += 0.1
                } else {
                    if(enemy.range == 0) {
                        wall.health -= Int(enemy.attack)
                    }
                    enemy.timer = 0
                    enemy.state = .reloading
                    animateEnemy(enemy: enemy)
                }
                break
            case .reloading:
                if(enemy.timer < enemy.reloadTimer) {
                    enemy.timer += 0.1
                } else {
                    enemy.timer = 0
                    enemy.state = .attacking
                    animateEnemy(enemy: enemy)
                }
                if(wall.health <= 0) {
                    enemy.state = .moving
                    animateEnemy(enemy: enemy)
                }
                break
            default:
                break
            }
        }
    }
    
    func arrowHitAnimation(enemy: Enemy) {
        var debrisColor: UIColor
        switch (enemy.type) {
        case .spearman:
            debrisColor = UIColor.red
            break
        case .catapult:
            debrisColor = UIColor.black
            break
        default:
            debrisColor = UIColor.red
            break
        }
        
        // loading debris pixels
        let debrisCount = arc4random_uniform(3)+2
        
        for _ in 1...debrisCount {
            let randAngle = -CGFloat(arc4random_uniform(50))*utils.pi/200.0
            let randForce = CGFloat(arc4random_uniform(20)+10)
            let pixel = SKSpriteNode()
            pixel.color = debrisColor
            pixel.size = CGSize(width: 5.0, height: 5.0)
            pixel.position = enemy.position
            pixel.zPosition = 2
            pixel.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 5, height: 5))
            pixel.physicsBody!.affectedByGravity = true
            pixel.physicsBody!.mass = 0.1
            
            pixel.physicsBody!.categoryBitMask = objectType.debris.rawValue
            pixel.physicsBody!.contactTestBitMask = objectType.screenBorder.rawValue
            pixel.physicsBody!.collisionBitMask = objectType.none.rawValue

            
            self.addChild(pixel)
            
            pixel.physicsBody!.applyImpulse(CGVector(dx: randForce*cos(randAngle), dy: randForce*sin(randAngle)))
        }
    }

    
    func animateEnemy(enemy: Enemy) {
        var movingTextures = [SKTexture]()
        var attackingTextures = [SKTexture]()
        var reloadingTextures = [SKTexture]()
            
        switch(enemy.type) {
        case .spearman:
            movingTextures = Graphics.spearmanMoving
            attackingTextures = Graphics.spearmanAttacking
            reloadingTextures = Graphics.spearmanReloading
            break
        case .knight:
            movingTextures = Graphics.knightMoving
            attackingTextures = Graphics.knightAttacking
            reloadingTextures = Graphics.knightReloading
        case .catapult:
            movingTextures = Graphics.catapultMoving
            attackingTextures = Graphics.catapultAttacking
            reloadingTextures = Graphics.catapultReloading
        default:
            break
        }
        
        switch(enemy.state) {
        case .moving:
            enemy.run(SKAction.repeatForever(SKAction.animate(with: movingTextures, timePerFrame: 0.1, resize: false, restore: true)), withKey: "enemyMoving")
            break
        case .attacking:
            enemy.removeAction(forKey: "enemyMoving")
            if(enemy.type == .catapult) {
                enemy.run(SKAction.animate(with: attackingTextures, timePerFrame: 0.02, resize: false, restore: false), completion: {() in self.loadProjectile(owner: enemy)})
            } else {
                enemy.run(SKAction.animate(with: attackingTextures, timePerFrame: 0.1, resize: false, restore: false), withKey: "enemyAttacking")
            }
            break
        case .reloading:
            enemy.removeAction(forKey: "enemyMoving")
            enemy.run(SKAction.animate(with: reloadingTextures, timePerFrame: 0.1, resize: false, restore: false), withKey: "enemyReloading")
            break
        default:
            break
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
            if(utils.distance(p1: location, p2: startLoc) >= 25) {
                let power = min(utils.distance(p1: location, p2: startLoc), 500)
                let angle = utils.arctan(opp: (startLoc.y-location.y), adj: (startLoc.x-location.x))
                if(splitShot) {
                    loadArrow(power: power, angle: angle-CGFloat(0.1), heatedShot: heatedShot)
                    loadArrow(power: power, angle: angle+CGFloat(0.1), heatedShot: heatedShot)
                    
                }
                loadArrow(power: power, angle: angle, heatedShot: heatedShot)
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let categoryMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        

        switch(categoryMask) {
        case objectType.arrow.rawValue | objectType.enemy.rawValue:
            if(contact.bodyA.categoryBitMask == objectType.arrow.rawValue) {
                contact.bodyA.node?.removeFromParent()
            } else {
                contact.bodyB.node?.removeFromParent()
            }
            let arrowIndex = arrows.index(where: {$0==contact.bodyA.node || $0==contact.bodyB.node})!
            let enemy = enemies[enemies.index(where: {$0==contact.bodyA.node || $0==contact.bodyB.node})!]
            
            // if enemy is not behind the tower
            if(enemy.zPosition == 4 || abs(enemy.position.x-tower.position.x) >= CGFloat(0.5)*tower.size.width) {
                if(arrows[arrowIndex].heatedShot && enemy.type == .catapult) {
                    enemy.health -= 4
                } else {
                    enemy.health -= 1
                }
                arrows.remove(at: arrowIndex)
                arrowHitAnimation(enemy: enemy)
            }

            break
        case objectType.arrow.rawValue | objectType.screenBorder.rawValue:
            if(contact.bodyA.categoryBitMask == objectType.arrow.rawValue) {
                contact.bodyA.node?.removeFromParent()
            } else {
                contact.bodyB.node?.removeFromParent()
            }
            arrows.remove(at: arrows.index(where: {$0==contact.bodyA.node || $0==contact.bodyB.node})!)
            break
        case objectType.debris.rawValue | objectType.screenBorder.rawValue:
            if(contact.bodyA.categoryBitMask == objectType.debris.rawValue) {
                contact.bodyA.node?.removeFromParent()
            } else {
                contact.bodyB.node?.removeFromParent()
            }
            break
        default:
            break
        }
    }
    
    func updateWall() {
        wall.health = max(0, wall.health)
        healthLabel.text = String(wall.health) + "/" + String(wall.maxHealth)
        let healthPercent = CGFloat(wall.health) / CGFloat(wall.maxHealth)
        if(healthPercent > 0.5 && healthPercent <= 0.75 ) {
            wall.texture = SKTexture(imageNamed: "wall-1")
        } else if (healthPercent > 0.25 && healthPercent <= 0.5) {
            wall.texture = SKTexture(imageNamed: "wall-2")
        } else if (healthPercent > 0 && healthPercent <= 0.25) {
            wall.texture = SKTexture(imageNamed: "wall-3")
        } else if (healthPercent <= 0) {
            wall.removeFromParent()
        }
    }
    
    func updateClouds() {
        for cloud in clouds {
            if(cloud.position.x >= 667+256) {
                cloud.removeFromParent()
                clouds.remove(at: clouds.index(where: {$0==cloud})!)
                loadCloud(newCloud: true)
            }
        }
    }
    
    
    func checkEndLevel() {
        if(enemies.count == 0 && level.timer <= 0) {
            gsDel?.player = player
            gsDel?.levelEnded()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        frameNumber = (frameNumber + 1) % 60

        updateClouds()
        updateArrows()
        updateEnemies()
        updateProjectiles()
        updateWall()
        checkEndLevel()
        
        if(frameNumber == 0) {
            level.timer -= 1;
        }
        
            if(arc4random_uniform(500) < min(30, level.levelNum) && level.timer > 0) {
                if(level.levelNum <= 6) {
                    loadEnemy(type: .spearman)
                } else if (level.levelNum <= 12) {
                    let rand = arc4random_uniform(2)
                    if(rand < 1) {
                        loadEnemy(type: .spearman)
                    } else {
                        loadEnemy(type: .knight)
                    }
                } else if (level.levelNum <= 18) {
                    let rand = arc4random_uniform(5)
                    if(rand < 3) {
                        loadEnemy(type: .spearman)
                    } else {
                        loadEnemy(type: .knight)
                    }
                } else {
                    let rand = arc4random_uniform(20)
                    if (rand < 9) {
                        loadEnemy(type: .spearman)
                    } else if (rand < 19)  {
                        loadEnemy(type: .knight)
                    } else {
                        loadEnemy(type: .catapult)
                        
                    }
                }
            }


        if(frameNumber == 0 && archers > 0) {
            for _ in 1...archers {
                if(arc4random_uniform(2) > 0) {
                    let power = CGFloat(200+arc4random_uniform(250))
                    let angle = utils.pi*(CGFloat(arc4random_uniform(25))*CGFloat(0.01))
                    loadArrow(power: power, angle: angle, heatedShot: false)
                }
            }

        }
    }
    
    deinit {
        print("releasing SKscene")
    }
}
