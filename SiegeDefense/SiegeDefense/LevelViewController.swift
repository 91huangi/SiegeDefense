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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let continueTap =  UITapGestureRecognizer(target: self, action: #selector(LevelViewController.onTapContinue))
        lblContinue.isUserInteractionEnabled = true
        lblContinue.addGestureRecognizer(continueTap)
        
        
    }
    
    func onTapContinue(sender: UITapGestureRecognizer) {
        // dismissing game view
        self.dismiss(animated: true, completion: {})
        
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        gameVC.player = player
        self.view?.window?.rootViewController = gameVC
    }
}
