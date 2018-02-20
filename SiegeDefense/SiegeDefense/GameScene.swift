//
//  GameScene.swift
//  SiegeDefense
//
//  Created by Ivan Huang on 2/19/18.
//  Copyright © 2018 Ivan Huang. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var touchLoc = [UITouch: CGPoint]()
    private var utils = Utils()
    
    var arrows = [SKSpriteNode]()
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.scene?.backgroundColor = UIColor.white

    }
    
    
    func updateArrows() {
        for arrow in arrows {
            var physBod = arrow.physicsBody!
            arrow.run(SKAction.rotate(toAngle: utils.arctan(r: physBod.velocity.dy/physBod.velocity.dx), duration: 0))
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
                let power = min(utils.distance(p1: location, p2: startLoc), 400)
                let angle = utils.arctan(r: (startLoc.y-location.y)/(startLoc.x-location.x))
                var arrow = SKSpriteNode(imageNamed: "arrow")
                arrow.run(SKAction.colorize(with: UIColor.black, colorBlendFactor: 1.0, duration: 0.0))
                arrow.size = CGSize(width: 30, height: 3)
                arrow.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 3))
                arrow.position = CGPoint(x: -500, y: -200)
                arrow.physicsBody!.velocity.dx = 3*power*cos(angle)
                arrow.physicsBody!.velocity.dy = 3*power*sin(angle)
                arrow.physicsBody!.affectedByGravity=true
                arrow.physicsBody!.allowsRotation = true
                arrows.append(arrow)
                self.addChild(arrow)
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        updateArrows()
    }
}
