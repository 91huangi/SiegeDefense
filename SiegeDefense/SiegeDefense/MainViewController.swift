//
//  MainViewController.swift
//  SiegeDefense
//
//  Created by Ivan Huang on 2/27/18.
//  Copyright © 2018 Ivan Huang. All rights reserved.
//

import Foundation
import UIKit

class MainViewController:UIViewController {
    @IBOutlet weak var lblStart: UILabel!
    @IBOutlet weak var lblTutorial: UILabel!
    @IBOutlet weak var lblEnemies: UILabel!
    @IBOutlet weak var lblLoad: UILabel!
    @IBOutlet weak var lblCredits: UILabel!
    @IBOutlet weak var lblExit: UILabel!
    
    
    @IBOutlet weak var lblMessage: UILabel!

    static var player: Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLabels()
        

        
        MusicPlayer.loadMenuMusic()
        
        Graphics.loadAnimations()
        Player.player = Player()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblMessage.isHidden = true
    }
    
    func loadLabels() {
        
        let tutorialTap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.onTapTutorial))
        lblTutorial.isUserInteractionEnabled = true
        lblTutorial.addGestureRecognizer(tutorialTap)
        
        let enemiesTap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.onTapEnemies))
        lblEnemies.isUserInteractionEnabled = true
        lblEnemies.addGestureRecognizer(enemiesTap)
        
        let loadTap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.onTapLoad))
        lblLoad.isUserInteractionEnabled = true
        lblLoad.addGestureRecognizer(loadTap)
        
        let creditsTap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.onTapCredits))
        lblCredits.isUserInteractionEnabled = true
        lblCredits.addGestureRecognizer(creditsTap)
        
        let exitTap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.onTapExit))
        lblExit.isUserInteractionEnabled = true
        lblExit.addGestureRecognizer(exitTap)
        
        
        let startTap =  UITapGestureRecognizer(target: self, action: #selector(MainViewController.onTapStart))
        lblStart.isUserInteractionEnabled = true
        lblStart.addGestureRecognizer(startTap)
    }
    
    func onTapTutorial(sender: UITapGestureRecognizer) {
        
        Player.player = Player()
        Player.player.levelNum = 0
        
        // self.view?.window?.rootViewController = gameVC
        self.performSegue(withIdentifier: "GameSegue", sender: self)
        // MusicPlayer.loadLevelMusic()
    }
    
    func onTapEnemies(sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "EnemiesSegue", sender: self)
    }
    
    func onTapCredits(sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "CreditsSegue", sender: self)
    }
    
    func onTapExit(sender: UITapGestureRecognizer) {
        exit(0);
    }
    
    func onTapLoad(sender: UITapGestureRecognizer) {
        let defaults = UserDefaults.standard
        let levelNum = defaults.integer(forKey: "LevelNum")
        if levelNum != 0 {
            Player.player = Player()
            Player.player.levelNum = levelNum
            Player.player.score = defaults.integer(forKey: "Score")
            Player.player.splitShot = defaults.bool(forKey: "3BoltCrossbow")
            Player.player.bodkinArrow = defaults.bool(forKey: "BodkinArrowhead")
            Player.player.wallMaxHealth = defaults.integer(forKey: "WallMaxHealth")
            Player.player.wallHealth = defaults.integer(forKey: "WallHealth")
            Player.player.archeryRange = defaults.bool(forKey: "ArcheryRange")
            Player.player.archers = defaults.integer(forKey: "Archers")
            Player.player.gold = defaults.integer(forKey: "Gold")
            self.performSegue(withIdentifier: "GameSegue", sender: self)
            MusicPlayer.loadLevelMusic()
        } else {
            lblMessage.text = "No games saved"
            lblMessage.isHidden = false
        }
    }

    
    func onTapStart(sender: UITapGestureRecognizer) {
        
        
        Player.player = Player()
        
        // Max out stats
        
        /*
        Player.player.levelNum = 24
        Player.player.splitShot = true
        Player.player.bodkinArrow = true
        Player.player.wallMaxHealth = 300
        Player.player.wallHealth = 300
        Player.player.archeryRange = true
        Player.player.archers = 6
        Player.player.gold = 300
        */
        
        
        self.performSegue(withIdentifier: "GameSegue", sender: self)
        MusicPlayer.loadLevelMusic()
    }
    
    deinit {
        print("releasing MainVC")
    }
        
        

}
