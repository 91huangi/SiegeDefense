//
//  LevelViewController.swift
//  SiegeDefense
//
//  Created by Ivan Huang on 2/28/18.
//  Copyright © 2018 Ivan Huang. All rights reserved.
//

import Foundation
import UIKit

class LevelViewController:UIViewController {

    var player: Player?
    @IBOutlet weak var lblContinue: UILabel!
    @IBOutlet weak var lblGold: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblWallHealth: UILabel!
    @IBOutlet weak var lblSplitShot: UILabel!
    @IBOutlet weak var lblHeatedShot: UILabel!
    @IBOutlet weak var lblMasonry: UILabel!
    @IBOutlet weak var lblRepair10: UILabel!
    @IBOutlet weak var lblRepair50: UILabel!
    @IBOutlet weak var lblArcheryRange: UILabel!
    @IBOutlet weak var lblHireArcher: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblScore.text = "Score: "+String(player!.score)
        
        let continueTap =  UITapGestureRecognizer(target: self, action: #selector(LevelViewController.onTapContinue))
        lblContinue.isUserInteractionEnabled = true
        lblContinue.addGestureRecognizer(continueTap)
        
        let splitShotTap =  UITapGestureRecognizer(target: self, action: #selector(LevelViewController.onTapSplitShot))
        lblSplitShot.isUserInteractionEnabled = true
        lblSplitShot.addGestureRecognizer(splitShotTap)
        
        let heatedShotTap =  UITapGestureRecognizer(target: self, action: #selector(LevelViewController.onTapHeatedShot))
        lblHeatedShot.isUserInteractionEnabled = true
        lblHeatedShot.addGestureRecognizer(heatedShotTap)
        
        let masonryTap =  UITapGestureRecognizer(target: self, action: #selector(LevelViewController.onTapMasonry))
        lblMasonry.isUserInteractionEnabled = true
        lblMasonry.addGestureRecognizer(masonryTap)
        
        let repair10Tap =  UITapGestureRecognizer(target: self, action: #selector(LevelViewController.onTapRepair10))
        lblRepair10.isUserInteractionEnabled = true
        lblRepair10.addGestureRecognizer(repair10Tap)
        
        let repair50Tap =  UITapGestureRecognizer(target: self, action: #selector(LevelViewController.onTapRepair50))
        lblRepair50.isUserInteractionEnabled = true
        lblRepair50.addGestureRecognizer(repair50Tap)
        
        let archeryRangeTap =  UITapGestureRecognizer(target: self, action: #selector(LevelViewController.onTapArcheryRange))
        lblArcheryRange.isUserInteractionEnabled = true
        lblArcheryRange.addGestureRecognizer(archeryRangeTap)
        
        let hireArcherTap =  UITapGestureRecognizer(target: self, action: #selector(LevelViewController.onTapHireArcher))
        lblHireArcher.isUserInteractionEnabled = true
        lblHireArcher.text = "Hire Archer "+String(player!.archers)+"/10 - 500g"
        lblHireArcher.addGestureRecognizer(hireArcherTap)
        
        
        
        updateLabels()
    }
    
    func updateLabels() {
        lblGold.text = "Gold: "+String(player!.gold)
        lblWallHealth.text = String(player!.wallHealth) + "/"+String(player!.wallMaxHealth)
    }
    
    func onTapSplitShot(sender: UITapGestureRecognizer) {
        player!.gold -= 150
        player!.splitShot = true
        updateLabels()
    }
    
    func onTapHeatedShot(sender: UITapGestureRecognizer) {
        player!.gold -= 500
        player!.heatedShot = true
        updateLabels()
    }
    
    func onTapMasonry(sender: UITapGestureRecognizer) {
        player!.wallMaxHealth = 300
        player!.gold -= 500
        updateLabels()
    }
    
    func onTapRepair10(sender: UITapGestureRecognizer) {
        player!.wallHealth = min(player!.wallHealth+10, player!.wallMaxHealth)
        player!.gold -= 50
        updateLabels()
    }
    
    func onTapRepair50(sender: UITapGestureRecognizer) {
        player!.wallHealth = min(player!.wallHealth+50, player!.wallMaxHealth)
        player!.gold -= 200
        updateLabels()
    }
    
    func onTapArcheryRange(sender: UITapGestureRecognizer) {
        player!.archeryRange = true
        player!.gold -= 2000
        updateLabels()
    }
    
    func onTapHireArcher(sender: UITapGestureRecognizer) {
        player!.archers += 1
        player!.gold -= 500
        lblHireArcher.text = "Hire Archer "+String(player!.archers)+"/10 - 500g"
        updateLabels()
    }
    
    func onTapContinue(sender: UITapGestureRecognizer) {
        // dismissing game view
        self.dismiss(animated: true, completion: {})
        
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        gameVC.player = player
        self.view?.window?.rootViewController = gameVC
    }
    
    deinit {
        print("releasing LVC")
    }
}
