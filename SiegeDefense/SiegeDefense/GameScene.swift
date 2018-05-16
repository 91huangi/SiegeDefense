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
    func levelEnded(backToMain: Bool)
}

enum objectType:UInt32 {
    case none=0
    
    case wall=1
    case arrow=2
    case enemy=4
    case debris = 8
    case oil = 16
    
    case castleGround = 512
    case screenBorder=1024
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    weak var gsDel: GameSceneDelegate?
    weak var player: Player?
    
    var level: Level = Level(levelNum: -1)
    
    var touchLoc: [UITouch: CGPoint] = [:]
    var frameNumber: Int = 0

    
    var utils: Utils = Utils()
    
    var bottomBorder:SKSpriteNode = SKSpriteNode()
    var castleGround:SKSpriteNode = SKSpriteNode()

    var arrows: [Arrow] = []
    var enemies: [Enemy] = []
    var projectiles: [Projectile] = []
    var ground: SKSpriteNode = SKSpriteNode()
    var tower: SKSpriteNode = SKSpriteNode()
    var flag: SKSpriteNode = SKSpriteNode()
    
    var castle: Castle = Castle(health: 1, maxHealth: 1, imageNamed: "Castle-01")
    
    var enemiesHit: Int = 0
    var arrowsShot: Int = 0
    var enemiesKilled: Int = 0
    var levelComplete: Bool = false
    var oilLeft = 1
    var oilTime = 0
    
    // Special unit variables
    var targetLoaded = false
    var dragonLoaded = false
    var availableSiegeLanes: [Int] = [0, 1, 2, 3, 4]
    
    // Labels
    var healthLabel: SKLabelNode = SKLabelNode()
    var levelLabel: SKLabelNode = SKLabelNode()
    var enemiesKilledLabel: SKLabelNode = SKLabelNode()
    var oilImage: SKSpriteNode = SKSpriteNode()
    var oilLabel: SKLabelNode = SKLabelNode()
    var menuLabel: SKLabelNode = SKLabelNode()
    var tutorialLabel1: SKLabelNode = SKLabelNode()
    var tutorialLabel2: SKLabelNode = SKLabelNode()
    
    
    var levelOverBackground: SKSpriteNode = SKSpriteNode()
    var levelOverMainLabel: SKLabelNode = SKLabelNode()
    var levelOverSubLabel1: SKLabelNode = SKLabelNode()
    var levelOverSubLabel2: SKLabelNode = SKLabelNode()
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        // view.showsPhysics = true
        level = Level(levelNum: (player?.levelNum)!)

        self.backgroundColor=UIColor.white

        ground = SKSpriteNode(imageNamed: "Field-01")
        ground.position = CGPoint(x: 0, y: 0)
        ground.size = CGSize(width: 1334, height: 750)
        ground.zPosition = -1
        self.addChild(ground)
        
        // adding scene border
        bottomBorder.position = CGPoint(x:0, y:-370)
        bottomBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10000, height: 2))
        bottomBorder.physicsBody!.pinned=true
        bottomBorder.physicsBody!.categoryBitMask = objectType.screenBorder.rawValue
        bottomBorder.physicsBody!.contactTestBitMask = objectType.arrow.rawValue | objectType.debris.rawValue
        bottomBorder.physicsBody!.collisionBitMask = objectType.none.rawValue
        self.addChild(bottomBorder)
        
        
        
        // loading castle ground
        castleGround.position = CGPoint(x: -360, y: -190)
        castleGround.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1000, height: 10))
        castleGround.run(SKAction.rotate(toAngle: utils.pi / 4, duration: 0.0))
        castleGround.physicsBody!.pinned=true
        castleGround.physicsBody!.categoryBitMask = objectType.castleGround.rawValue
        castleGround.physicsBody!.contactTestBitMask = objectType.oil.rawValue
        castleGround.physicsBody!.collisionBitMask = objectType.none.rawValue
        self.addChild(castleGround)
        
        
        
        
        //loading flag
        flag = SKSpriteNode(imageNamed: "Flag-01")
        flag.size = CGSize(width: 87, height: 55)
        flag.position = CGPoint(x: castle.position.x-555, y: castle.position.y+105)
        flag.zPosition = castle.zPosition+1
        flag.run(SKAction.repeatForever(SKAction.animate(with: Graphics.flagFrames, timePerFrame: 0.1, resize: false, restore: true)), withKey: "flag-animation")
        self.addChild(flag)
        
        // loading level over background and labels
        let blackRect = SKShapeNode(rectOf: CGSize(width: 1334, height: 750))
        blackRect.fillColor = UIColor.black
        let blackBackground = self.view?.texture(from: blackRect)
        levelOverBackground = SKSpriteNode(texture: blackBackground)
        levelOverBackground.position = CGPoint(x: 0, y: 0)
        levelOverBackground.alpha = 0.0
        levelOverBackground.zPosition = 1000
        self.addChild(levelOverBackground)
        levelOverMainLabel.text = "Game Over"
        levelOverMainLabel.fontColor = UIColor.white
        levelOverMainLabel.position = CGPoint(x: 0, y: 100)
        levelOverMainLabel.zPosition = 1001
        levelOverMainLabel.alpha = 0.0
        levelOverMainLabel.fontSize = 64
        levelOverMainLabel.fontName = "Kingthings Spikeless"
        self.addChild(levelOverMainLabel)
        levelOverSubLabel1.text = "Accuracy: "
        levelOverSubLabel1.fontColor = UIColor.white
        levelOverSubLabel1.position = CGPoint(x: 0, y: 0)
        levelOverSubLabel1.zPosition = 1001
        levelOverSubLabel1.alpha = 0.0
        levelOverSubLabel1.fontSize = 48
        levelOverSubLabel1.fontName = "Baskerville Bold"
        self.addChild(levelOverSubLabel1)
        levelOverSubLabel2.text = "Level Score: "
        levelOverSubLabel2.fontColor = UIColor.white
        levelOverSubLabel2.position = CGPoint(x: 0, y: -100)
        levelOverSubLabel2.zPosition = 1001
        levelOverSubLabel2.alpha = 0.0
        levelOverSubLabel2.fontSize = 48
        levelOverSubLabel2.fontName = "Baskerville Bold"
        self.addChild(levelOverSubLabel2)
        

        
        
        // loading castle
        castle = Castle(health: player!.wallHealth, maxHealth: player!.wallMaxHealth, imageNamed: "Castle-01")
        castle.size = CGSize(width: 500, height: 425)
        castle.position = CGPoint(x: -420, y: -60)
        castle.zPosition = 0
        self.addChild(castle)
        
        

        loadLabels()
        
        


    }
    
    override func willMove(from view: SKView) {
        clean()
    }
    
    func loadLabels() {
        // loading labels
        healthLabel.position = CGPoint(x: -550, y: 325)
        healthLabel.fontColor = UIColor.white
        healthLabel.fontName = "Arial Bold"
        self.addChild(healthLabel)
        
        levelLabel.position = CGPoint(x: 0, y: 325)
        levelLabel.fontColor = UIColor.yellow
        levelLabel.fontName = "Kingthings Spikeless"
        levelLabel.fontSize = 48
        levelLabel.text = "Level "+String(level.levelNum)
        self.addChild(levelLabel)
        
        enemiesKilledLabel.position = CGPoint(x: 475, y: 325)
        enemiesKilledLabel.fontColor = UIColor.white
        enemiesKilledLabel.fontName = "Arial Bold"
        self.addChild(enemiesKilledLabel)
        
        
        oilImage = SKSpriteNode(imageNamed: "oil-cauldron")
        oilImage.size = CGSize(width: 75, height: 75)
        oilImage.position = CGPoint(x: 550, y: -325)
        oilImage.zPosition = 3
        self.addChild(oilImage)
        
        oilLabel.position = CGPoint(x: 555, y: -350)
        oilLabel.fontColor = UIColor.black
        oilLabel.fontName = "Arial Bold"
        oilLabel.zPosition = 4
        self.addChild(oilLabel)
        
        menuLabel.position = CGPoint(x:-570, y: -350)
        menuLabel.fontColor = UIColor.white
        menuLabel.fontName = "Kingthings Spikeless"
        menuLabel.text = "Menu"
        menuLabel.fontSize = 48
        menuLabel.zPosition = 4
        self.addChild(menuLabel)
        
        if(level.levelNum == 0) {
            tutorialLabel1.position = CGPoint(x: 0, y: 275)
            tutorialLabel1.fontName = "Arial Bold"
            tutorialLabel1.fontColor = UIColor.white
            tutorialLabel1.text = "Click anywhere on the screen and drag opposite the direction of fire."
            tutorialLabel1.zPosition = 3
            tutorialLabel1.fontSize = 24
            self.addChild(tutorialLabel1)
            
            tutorialLabel2.position = CGPoint(x: 250, y: -350)
            tutorialLabel2.fontName = "Arial Bold"
            tutorialLabel2.fontColor = UIColor.white
            tutorialLabel2.text = "Press to pour burning oil down your walls"
            tutorialLabel2.zPosition = 3
            tutorialLabel2.fontSize = 24
            self.addChild(tutorialLabel2)
        }
    }
    
    func loadEnemy(type: Enemy.EnemyType) {
        var enemy: Enemy
        var isSiege = false
        
        switch(type) {
        case .target:
            enemy = Enemy(type: Enemy.EnemyType.target, imageNamed: "Target-01")
            enemy.size = CGSize(width: 80, height: 80)
            enemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 35, height: 80))
            targetLoaded = true
        case .spearman:
            enemy = Enemy(type: Enemy.EnemyType.spearman, imageNamed: "Spearman-01")
            enemy.size = CGSize(width: 80, height: 80)
            enemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 35, height: 35))

            break
        case .knight:
            enemy = Enemy(type: Enemy.EnemyType.knight, imageNamed: "Knight-01")
            enemy.size = CGSize(width: 65, height: 65)
            enemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 27, height: 54))
            break
        case .ram:
            // No where to put siege weapon
            if(availableSiegeLanes.count == 0) {
                return
            }
            isSiege = true

            enemy = Enemy(type: Enemy.EnemyType.ram, imageNamed: "Ram-01")
            enemy.size = CGSize(width: 128, height: 100)
            enemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 128, height: 48))
        case .catapult:
            // No where to put siege weapon
            if(availableSiegeLanes.count == 0) {
                return
            }
            isSiege = true

            enemy = Enemy(type: Enemy.EnemyType.catapult, imageNamed: "Catapult-01")
            
            enemy.size = CGSize(width: 128, height: 100)
            enemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 128, height: 48))

            break
        }


        enemy.state = .moving
        animateEnemy(enemy: enemy)
        
        // Targets loaded at random position, everything else loaded off screen
        if(level.levelNum == 0) {
            enemy.position = CGPoint(x: CGFloat(arc4random_uniform(700) - 100), y: -125+CGFloat(Int(arc4random_uniform(100)) - 25))
        } else {
            
            // Siege is loaded in lanes so they dont overlap
            if (isSiege) {
                var lane = availableSiegeLanes[Int(arc4random_uniform(UInt32(availableSiegeLanes.count)))]
                enemy.position = CGPoint(x: 765, y: -160+30*CGFloat(lane))
                availableSiegeLanes.remove(at: availableSiegeLanes.index(where: {$0==lane})!)
            } else {
                enemy.position = CGPoint(x: 765, y: -150+CGFloat(arc4random_uniform(100)))
            }

        }
        
        enemy.physicsBody!.categoryBitMask = objectType.enemy.rawValue
        enemy.physicsBody!.contactTestBitMask = objectType.arrow.rawValue | objectType.oil.rawValue
        enemy.physicsBody!.collisionBitMask = objectType.none.rawValue
        enemy.physicsBody!.affectedByGravity = false
        
        enemy.zPosition = abs(enemy.position.y-0.5*enemy.size.height)
        
        enemies.append(enemy)
        self.addChild(enemy)
    }
    
    
    func loadArrow(power: CGFloat, angle: CGFloat, userOwned: Bool) {
        var arrow = Arrow(userOwned: userOwned, imageNamed: "Arrow")
        arrow.size = CGSize(width: 50, height: 5)
        if(userOwned) {
            arrowsShot += 1
        }
        arrow.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 5))
        
        // user fires from middle window
        if(userOwned) {
            arrow.position = CGPoint(x: castle.position.x-115, y: castle.position.y+100)
        } else {
            
            // archers fire randomly from left or right windows
            if(arc4random_uniform(2) < 1) {
                arrow.position = CGPoint(x: castle.position.x-95, y: castle.position.y+120)
            } else {
                arrow.position = CGPoint(x: castle.position.x-135, y: castle.position.y+80)
            }
        }
        arrow.physicsBody!.velocity.dx = 3*power*cos(angle)
        arrow.physicsBody!.velocity.dy = 3*power*sin(angle)
        arrow.physicsBody!.affectedByGravity=true
        arrow.physicsBody!.allowsRotation = true
        arrow.physicsBody!.categoryBitMask = objectType.arrow.rawValue
        arrow.physicsBody!.contactTestBitMask = objectType.enemy.rawValue | objectType.screenBorder.rawValue
        arrow.physicsBody!.collisionBitMask = objectType.none.rawValue
        arrow.zPosition = castle.zPosition+2
        arrows.append(arrow)
        self.addChild(arrow)
    }
    
    func gameOver() {
        levelOverBackground.run(SKAction.fadeAlpha(to: 1.0, duration: 0.3))
        levelOverMainLabel.run(SKAction.fadeAlpha(to: 1.0, duration: 0.3))
    }
    
    
    func loadProjectile(owner: Enemy) {
        
        
        let rock = SKShapeNode(circleOfRadius: 6.0)
        rock.lineWidth = 0.0
        rock.fillColor = UIColor.black
        let rockTexture = view?.texture(from: rock)
        
        var projectile = Projectile(owner: owner, texture: rockTexture!)

        projectile.position = CGPoint(x: owner.position.x, y: owner.position.y+15)
        
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
            if(projectile.position.x <= CGFloat(castle.position.x) ) {
                castle.health -= Int(projectile.owner.attack)
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
                if(enemy.type == .ram || enemy.type == .catapult) {
                    availableSiegeLanes.append(Int(round((enemy.position.y + 160.0)/30.0)))
                }
                enemy.removeAllActions()
                enemy.removeFromParent()
                enemies.remove(at: enemies.index(where: {$0==enemy})!)
                continue
            }
            
            switch(enemy.state) {
            case .moving:
                enemy.physicsBody!.velocity.dx = -enemy.enemySpeed
                if(castle.health > 0 && (enemy.position.x - 0.5*enemy.size.width - enemy.range <= castle.position.x+castle.offset-(ground.position.y-enemy.position.y))) {
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
                        castle.health -= Int(enemy.attack)
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
                if(castle.health <= 0) {
                    enemy.state = .moving
                    animateEnemy(enemy: enemy)
                }
                break
            default:
                break
            }
        }
    }
    
    func arrowHit(arrow: Arrow, enemy: Enemy) {
        
        var debrisColor: UIColor
        switch (enemy.type) {
        case .target:
            debrisColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
            targetLoaded = false
        case .ram:
            debrisColor = Graphics.siegeColor
            break
        case .catapult:
            debrisColor = Graphics.siegeColor
            break
        default:
            debrisColor = UIColor.red
            break
        }
        
        // kill enemy
        if(enemy.health <= 0) {
            if(arrow.userOwned) {
                level.score += enemy.type.rawValue
                enemiesKilled += 1
                enemiesHit += 1
            }
        }
        
        // loading debris pixels
        let debrisCount = arc4random_uniform(3)+2
        
        for i in 1...debrisCount {
            let randAngle = -CGFloat(arc4random_uniform(50))*utils.pi/200.0
            let randForce = CGFloat(arc4random_uniform(20)+10)
            let pixel = SKSpriteNode()
            pixel.color = debrisColor
            pixel.size = CGSize(width: 5.0, height: 5.0)
            pixel.position = enemy.position
            pixel.zPosition = enemy.zPosition
            pixel.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 5, height: 5))
            pixel.physicsBody!.affectedByGravity = true
            pixel.physicsBody!.mass = 0.1
            
            pixel.physicsBody!.categoryBitMask = objectType.debris.rawValue
            pixel.physicsBody!.contactTestBitMask = objectType.screenBorder.rawValue
            pixel.physicsBody!.collisionBitMask = objectType.none.rawValue
            pixel.run(SKAction.fadeAlpha(to: 0, duration: Double(i) / Double(debrisCount*2)))
            
            self.addChild(pixel)
            
            pixel.physicsBody!.applyImpulse(CGVector(dx: randForce*cos(randAngle), dy: randForce*sin(randAngle)))
        }
    }

    
    func animateEnemy(enemy: Enemy) {
        var movingTextures = [SKTexture]()
        var attackingTextures = [SKTexture]()
        var reloadingTextures = [SKTexture]()
            
        switch(enemy.type) {
        case .target:
            movingTextures = Graphics.targetMoving
            attackingTextures = Graphics.targetAttacking
            reloadingTextures = Graphics.targetReloading
        case .spearman:
            movingTextures = Graphics.spearmanMoving
            attackingTextures = Graphics.spearmanAttacking
            reloadingTextures = Graphics.spearmanReloading
            break
        case .knight:
            movingTextures = Graphics.knightMoving
            attackingTextures = Graphics.knightAttacking
            reloadingTextures = Graphics.knightReloading
        case .ram:
            movingTextures = Graphics.ramMoving
            attackingTextures = Graphics.ramAttacking
            reloadingTextures = Graphics.ramReloading
        case .catapult:
            movingTextures = Graphics.catapultMoving
            attackingTextures = Graphics.catapultAttacking
            reloadingTextures = Graphics.catapultReloading
        default:
            break
        }
        
        
        switch(enemy.state) {
        case .moving:
            enemy.run(SKAction.repeatForever(SKAction.animate(with: movingTextures, timePerFrame: 0.10, resize: false, restore: true)), withKey: "enemyMoving")
            break
        case .attacking:
            enemy.removeAction(forKey: "enemyMoving")
            if(enemy.type == .catapult) {
                enemy.run(SKAction.animate(with: attackingTextures, timePerFrame: 0.01, resize: false, restore: false), completion: {() in self.loadProjectile(owner: enemy)})
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
    
    func useOil() {

        oilTime -= 1
        // loading debris pixels
        for i in -3...3 {
            for _ in 0...2 {
                let randAngle = -CGFloat(arc4random_uniform(5))*utils.pi/40.0
                let randForce = CGFloat(20)
                let size = CGFloat(6)
                let mass = CGFloat(0.4)
                let pixel = SKSpriteNode()
                //let ro = CGFloat(arc4random_uniform(2))
                pixel.color = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
                
                pixel.size = CGSize(width: size, height: size)
                pixel.position = CGPoint(x: -330+23*CGFloat(i)-5+CGFloat(arc4random_uniform(11)), y: -40+23*CGFloat(i)-5+CGFloat(arc4random_uniform(11)))
                pixel.zPosition = 999
                pixel.physicsBody = SKPhysicsBody(circleOfRadius: 0.5*size)
                pixel.physicsBody!.affectedByGravity = true
                pixel.physicsBody!.restitution=1.0
                pixel.physicsBody!.mass = mass
                
                pixel.physicsBody!.categoryBitMask = objectType.oil.rawValue
                pixel.physicsBody!.contactTestBitMask = objectType.castleGround.rawValue | objectType.enemy.rawValue
                pixel.physicsBody!.collisionBitMask = objectType.none.rawValue
                
                self.addChild(pixel)
                
                pixel.physicsBody!.applyImpulse(CGVector(dx: randForce*cos(randAngle), dy: randForce*sin(randAngle)))
            }
 
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(levelOverBackground.alpha >= 0.99) {
            if(levelOverMainLabel.text?.substring(to: String.Index.init(1)) == "L" ){
                endLevel(gameOver: false)
            } else {
                endLevel(gameOver: true)
            }
        }
        for t in touches {
            let location = t.location(in: self)
            
            // selecting menu
            if (utils.distance(p1: location, p2: menuLabel.position) < 40) {
                endLevel(gameOver: true)
            }
            
            
            // selecting oil
            if (utils.distance(p1: location, p2: oilImage.position) < 40) {
                if(oilLeft > 0) {
                    oilTime = 100
                    oilLeft -= 1
                }
            }
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
                
                // can only fire foward
                if(angle >= 1.5*utils.pi || angle <= 0.5*utils.pi) {
                    if(player!.splitShot) {
                        loadArrow(power: power, angle: angle-CGFloat(0.1), userOwned: true)
                        loadArrow(power: power, angle: angle+CGFloat(0.1), userOwned: true)
                    }
                    loadArrow(power: power, angle: angle, userOwned: true)
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let categoryMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        

        switch(categoryMask) {
        
        case objectType.oil.rawValue | objectType.enemy.rawValue:
            if(enemies.index(where: {$0==contact.bodyA.node || $0==contact.bodyB.node}) != nil) {
                let enemyIndex = enemies.index(where: {$0==contact.bodyA.node || $0==contact.bodyB.node})!
                enemies[enemyIndex].health -= 0.02
            }
            break
        case objectType.arrow.rawValue | objectType.enemy.rawValue:
            var arrowIndex = -1
            if(arrows.index(where: {$0==contact.bodyA.node || $0==contact.bodyB.node}) != nil)
            {
                arrowIndex = arrows.index(where: {$0==contact.bodyA.node || $0==contact.bodyB.node})!
            }
            var enemyIndex = -1
            if(enemies.index(where: {$0==contact.bodyA.node || $0==contact.bodyB.node}) != nil) {
                enemyIndex = enemies.index(where: {$0==contact.bodyA.node || $0==contact.bodyB.node})!
            }

            
            // In case arrow hits two targets at once
            if(arrowIndex >= 0) {
                
                // In case an enemy is hit by more than one arrow at once
                if(enemyIndex >= 0) {
                    enemies[enemyIndex].health -= 1
                    arrowHit(arrow: arrows[arrowIndex], enemy: enemies[enemyIndex])
                }

                // If bodkin arrowhead is true 50% chance of arrow piercing
                if(!(player?.bodkinArrow)! || arc4random_uniform(2) < 1) {
                    arrows.remove(at: arrowIndex)
                    if(contact.bodyA.categoryBitMask == objectType.arrow.rawValue) {
                        contact.bodyA.node?.removeFromParent()
                    } else {
                        contact.bodyB.node?.removeFromParent()
                    }
                }
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
        
        case objectType.oil.rawValue | objectType.castleGround.rawValue:
            if(contact.bodyA.categoryBitMask == objectType.oil.rawValue) {
                contact.bodyA.node?.removeFromParent()
            } else {
                contact.bodyB.node?.removeFromParent()
            }
            break
        default:
            break
        }
    }
    
    func updateCastle() {
        castle.health = max(0, castle.health)
        let healthPercent = CGFloat(castle.health) / CGFloat(castle.maxHealth)
        if(healthPercent > 0.6 && healthPercent <= 0.8 ) {
            castle.texture = SKTexture(imageNamed: "Castle-02")
        } else if (healthPercent > 0.4 && healthPercent <= 0.6) {
            castle.texture = SKTexture(imageNamed: "Castle-03")
        } else if (healthPercent > 0.2 && healthPercent <= 0.4) {
            castle.texture = SKTexture(imageNamed: "Castle-04")
        } else if (healthPercent > 0 && healthPercent <= 0.2) {
            castle.texture = SKTexture(imageNamed: "Castle-05")
        } else if (healthPercent <= 0) {
            castle.texture = SKTexture(imageNamed: "Castle-06")
        }
    }
    
    
    func updateLabels() {
        healthLabel.text = "Wall: " + String(castle.health) + "/" + String(castle.maxHealth)
        enemiesKilledLabel.text = "Enemies Killed: "+String(enemiesKilled)
        oilLabel.text = "x" + String(oilLeft)
    }
    
    
    func endLevel(gameOver: Bool) {
        gsDel?.levelEnded(backToMain: gameOver)
    }
    
    func checkEndLevel() {
        if(castle.health <= 0) {
            gameOver()
        }
        if(enemies.count == 0 && level.timer <= 0 && !levelComplete && level.levelNum > 0) {
            var accuracy: Double = 0.0
            if(arrowsShot > 0) {
                accuracy = min(1.0, Double(enemiesHit) / Double(arrowsShot))
            } else {
                accuracy = 1.0
            }
            let levelScore = Int(Double(level.score) * (1.0+accuracy))
            player!.score += levelScore
            player!.gold += levelScore
            player!.wallHealth = castle.health
            
            levelOverBackground.run(SKAction.fadeAlpha(to: 1.0, duration: 0.3))
            levelOverMainLabel.text = "Level " + String(player!.levelNum) + " Complete"
            levelOverMainLabel.run(SKAction.fadeAlpha(to: 1.0, duration: 0.3))
            levelOverSubLabel1.text = "Accuracy: " + String(describing: Int(100.0*accuracy)) + "%"
            levelOverSubLabel1.run(SKAction.fadeAlpha(to: 1.0, duration: 0.3))
            levelOverSubLabel2.text = "Level Score: " + String(levelScore)
            levelOverSubLabel2.run(SKAction.fadeAlpha(to: 1.0, duration: 0.3))
            
            levelComplete = true
        }
    }
    
    func clean() {
        self.removeAllActions()
        self.removeAllChildren()
        castleGround = SKSpriteNode()
        bottomBorder = SKSpriteNode()
        healthLabel = SKLabelNode()
        levelLabel = SKLabelNode()
        ground = SKSpriteNode()
        level = Level(levelNum: -1)
        utils = Utils()
        
        for enemy in enemies {
            enemy.removeFromParent()
        }
        enemies.removeAll()
    }
    
    
    func chooseEnemyToLoad() {
        if(level.levelNum == 0 && !targetLoaded) {
            loadEnemy(type: .target)
        }
        
        if(level.levelNum != 0 && arc4random_uniform(500) < max(level.levelNum, 2) && level.timer > 0) {
            if(level.levelNum <= 6) {
                loadEnemy(type: .spearman)
            } else if (level.levelNum <= 12) {
                let rand = arc4random_uniform(7)
                if(rand < 5) {
                    loadEnemy(type: .spearman)
                } else {
                    loadEnemy(type: .knight)
                }
            } else if (level.levelNum <= 15) {
                let rand = arc4random_uniform(2)
                if(rand < 1) {
                    loadEnemy(type: .spearman)
                } else {
                    loadEnemy(type: .knight)
                }
            } else if (level.levelNum <= 23) {
                let rand = arc4random_uniform(31)
                if(rand < 15) {
                    loadEnemy(type: .spearman)
                } else if(rand < 30){
                    loadEnemy(type: .knight)
                } else {
                    loadEnemy(type: .ram)
                }
            } else if (level.levelNum <= 29) {
                let rand = arc4random_uniform(32)
                if (rand < 15) {
                    loadEnemy(type: .spearman)
                } else if (rand < 30)  {
                    loadEnemy(type: .knight)
                } else if (rand < 31) {
                    loadEnemy(type: .ram)
                } else {
                    loadEnemy(type: .catapult)
                }
            }
        }
        
        if(level.levelNum == 30 && level.timer <= 10 && !dragonLoaded) {
            
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        frameNumber = (frameNumber + 1) % 60

        updateArrows()
        updateEnemies()
        updateProjectiles()
        updateCastle()
        updateLabels()
        checkEndLevel()
        chooseEnemyToLoad()
        
        
        if(oilTime > 0) {
            useOil()
        }
        
        if(frameNumber == 0) {
            level.timer -= 1;
        }
        



        if(frameNumber == 0 && player!.archers > 0) {
            for _ in 1...player!.archers {
                if(arc4random_uniform(2) > 0) {
                    let power = CGFloat(200+arc4random_uniform(250))
                    let angle = utils.pi*(CGFloat(arc4random_uniform(25))*CGFloat(0.01))
                    loadArrow(power: power, angle: angle, userOwned: false)
                }
            }

        }
    }
    
    deinit {
        print("releasing SKscene")
    }
}
