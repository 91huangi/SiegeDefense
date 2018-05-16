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

    weak var scene:GameScene?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            scene = GameScene(fileNamed: "GameScene")
            // Set the scale mode to scale to fit the window
            scene?.scaleMode = .aspectFill
            scene!.gsDel = self
            scene!.player = Player.player
            
            
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
    
    func levelEnded(backToMain: Bool) {
        
        if(backToMain) {
            self.dismiss(animated: true, completion: {})
            MusicPlayer.loadMenuMusic()
        } else {
            self.performSegue(withIdentifier: "LevelSegue", sender: self)
            MusicPlayer.loadShopMusic()
        }
        
        


    }
    
    deinit {
        print("releasing GVC")
    }
}
