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

    var gameVC: GameViewController?
    var grayText = UIColor.darkGray
    @IBOutlet weak var lblContinue: UILabel!
    @IBOutlet weak var lblGold: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblWallHealth: UILabel!
    @IBOutlet weak var lblSplitShot: UILabel!
    @IBOutlet weak var lblSplitShotDesc: UILabel!
    @IBOutlet weak var lblBodkinArrow: UILabel!
    @IBOutlet weak var lblBodkinArrowDesc: UILabel!
    @IBOutlet weak var lblMasonry: UILabel!
    @IBOutlet weak var lblMasonryDesc: UILabel!
    @IBOutlet weak var lblRepair10: UILabel!
    @IBOutlet weak var lblRepair50: UILabel!
    @IBOutlet weak var lblArcheryRange: UILabel!
    @IBOutlet weak var lblArcheryRangeDesc: UILabel!
    @IBOutlet weak var lblHireArcher: UILabel!
    @IBOutlet weak var lblHireArcherDesc: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblScore.text = "Score: "+String(Player.player.score)
        
        let continueTap =  UITapGestureRecognizer(target: self, action: #selector(LevelViewController.onTapContinue))
        lblContinue.isUserInteractionEnabled = true
        lblContinue.addGestureRecognizer(continueTap)
        
        let bodkinArrowTap =  UITapGestureRecognizer(target: self, action: #selector(LevelViewController.onBodkinArrow))
        lblBodkinArrow.isUserInteractionEnabled = true
        lblBodkinArrow.addGestureRecognizer(bodkinArrowTap)
        
        let splitShotTap =  UITapGestureRecognizer(target: self, action: #selector(LevelViewController.onTapSplitShot))
        lblSplitShot.isUserInteractionEnabled = true
        lblSplitShot.addGestureRecognizer(splitShotTap)
        
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
        lblHireArcher.text = "Hire Archer "+String(Player.player.archers)+"/10 | 500g"
        lblHireArcher.addGestureRecognizer(hireArcherTap)
        
        if(gameVC == nil) {
            gameVC = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        }
        
        
        updateLabels()
    }
    
    func saveDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(Player.player.levelNum, forKey: "LevelNum")
        defaults.set(Player.player.score, forKey: "Score")
        defaults.set(Player.player.gold, forKey: "Gold")
        defaults.set(Player.player.bodkinArrow, forKey: "BodkinArrowhead")
        defaults.set(Player.player.splitShot, forKey: "3BoltCrossbow")
        defaults.set(Player.player.wallHealth, forKey: "WallHealth")
        defaults.set(Player.player.wallMaxHealth, forKey: "WallMaxHealth")
        defaults.set(Player.player.archeryRange, forKey: "ArcheryRange")
        defaults.set(Player.player.archers, forKey: "Archers")
    }
    
    
    func updateLabels() {
        lblMessage.isHidden = true
        lblGold.text = "Gold: "+String(Player.player.gold)
        lblWallHealth.text = String(Player.player.wallHealth) + "/"+String(Player.player.wallMaxHealth)
        if(Player.player.bodkinArrow) {
            lblBodkinArrow.textColor = grayText
            lblBodkinArrowDesc.textColor = grayText
        }
        if(Player.player.splitShot) {
            lblSplitShot.textColor = grayText
            lblSplitShotDesc.textColor = grayText
        }
        if(Player.player.wallMaxHealth == 300) {
            lblMasonry.textColor = grayText
            lblMasonryDesc.textColor = grayText
        }
        if(Player.player.archeryRange) {
            lblArcheryRange.textColor = grayText
            lblArcheryRangeDesc.textColor = grayText
        }
        if(Player.player.archers >= 10) {
            lblHireArcher.textColor = grayText
            lblHireArcherDesc.textColor = grayText
        }
    }
    
    func displayMessage(message: String) {
        lblMessage.text = message
        lblMessage.isHidden = false
    }
    

    
    func onBodkinArrow(sender: UITapGestureRecognizer) {
        if(lblBodkinArrow.textColor == grayText) {
            return
        }
        if(Player.player.gold < 150) {
            displayMessage(message: "Not enough gold for purchase")
            return
        }
        Player.player.gold -= 150
        Player.player.bodkinArrow = true
        updateLabels()
    }
    
    func onTapSplitShot(sender: UITapGestureRecognizer) {
        if(lblSplitShot.textColor == grayText) {
            return
        }
        if(Player.player.gold < 500) {
            displayMessage(message: "Not enough gold for purchase")
            return
        }
        Player.player.gold -= 500
        Player.player.splitShot = true
        updateLabels()
    }
    
    func onTapMasonry(sender: UITapGestureRecognizer) {
        if(lblMasonry.textColor == grayText) {
            return
        }
        if(Player.player.gold < 650) {
            displayMessage(message: "Not enough gold for purchase")
            return
        }
        Player.player.wallMaxHealth = 300
        Player.player.wallHealth += 200
        Player.player.gold -= 650
        updateLabels()
    }
    
    func onTapRepair10(sender: UITapGestureRecognizer) {
        if(Player.player.wallHealth >= Player.player.wallMaxHealth) {
            displayMessage(message: "Wall already fully repaired")
            return
        }
        if(Player.player.gold < 10) {
            displayMessage(message: "Not enough gold for purchase")
            return
        }
        Player.player.wallHealth = min(Player.player.wallHealth+10, Player.player.wallMaxHealth)
        Player.player.gold -= 10
        updateLabels()
    }
    
    func onTapRepair50(sender: UITapGestureRecognizer) {
        if(Player.player.wallHealth >= Player.player.wallMaxHealth) {
            displayMessage(message: "Wall already fully repaired")
            return
        }
        if(Player.player.gold < 40) {
            displayMessage(message: "Not enough gold for purchase")
            return
        }
        Player.player.wallHealth = min(Player.player.wallHealth+50, Player.player.wallMaxHealth)
        Player.player.gold -= 40
        updateLabels()
    }
    
    func onTapArcheryRange(sender: UITapGestureRecognizer) {
        if(lblArcheryRange.textColor == grayText) {
            return
        }
        if(Player.player.gold < 2000) {
            displayMessage(message: "Not enough gold for purchase")
            return
        }
        Player.player.archeryRange = true
        Player.player.gold -= 2000
        updateLabels()
    }
    
    func onTapHireArcher(sender: UITapGestureRecognizer) {
        if(lblHireArcher.textColor == grayText) {
            return
        }
        if(!Player.player.archeryRange) {
            displayMessage(message: "Must construct archery range before hiring archers")
            return
        }
        if(Player.player.gold < 500) {
            displayMessage(message: "Not enough gold for purchase")
            return
        }
        Player.player.archers += 1
        Player.player.gold -= 500
        lblHireArcher.text = "Hire Archer "+String(Player.player.archers)+"/10 | 500g"
        updateLabels()
    }
    
    func onTapContinue(sender: UITapGestureRecognizer) {
        Player.player.levelNum += 1
        saveDefaults()
        self.dismiss(animated: true, completion: {})
        MusicPlayer.loadLevelMusic()
    }
    
    deinit {
        print("releasing LVC")
    }
}
