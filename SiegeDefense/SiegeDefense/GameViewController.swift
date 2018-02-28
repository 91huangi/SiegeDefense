//
//  GameViewController.swift
//  SiegeDefense
//
//  Created by Ivan Huang on 2/19/18.
//  Copyright © 2018 Ivan Huang. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, GameSceneDelegate {

    weak var scene:GameScene? = GameScene()
    var player: Player?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            scene = GameScene(fileNamed: "GameScene")
            // Set the scale mode to scale to fit the window
            scene?.scaleMode = .aspectFill
            scene!.gsDel = self
            scene!.player = player!


            // Present the scene
            view.presentScene(scene)

            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func levelEnded() {
        // dismissing game view
        self.dismiss(animated: true, completion: {})
        
        scene!.removeAllActions()
        scene!.removeAllChildren()
        
        let levelVC = self.storyboard?.instantiateViewController(withIdentifier: "LevelViewController") as! LevelViewController
        levelVC.player = player!
        self.view?.window?.rootViewController = levelVC
    }
}
