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
    
    var player: Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let startTap =  UITapGestureRecognizer(target: self, action: #selector(MainViewController.onTapStart))
        lblStart.isUserInteractionEnabled = true
        lblStart.addGestureRecognizer(startTap)
        
        player = Player()
        
        
    }
    
    func onTapStart(sender: UITapGestureRecognizer) {
        
        // dismissing game view
        self.dismiss(animated: true, completion: {})
        
        player!.levelNum = 1
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        gameVC.player = player
        self.view?.window?.rootViewController = gameVC
    }
        
        

}
