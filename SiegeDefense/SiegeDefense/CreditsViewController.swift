//
//  CreditsViewController.swift
//  SiegeDefense
//
//  Created by Ivan Huang on 5/7/18.
//  Copyright © 2018 Ivan Huang. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {

    @IBOutlet weak var lblMenu: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let menuTap = UITapGestureRecognizer(target: self, action: #selector(CreditsViewController.onTapMenu))
        lblMenu.isUserInteractionEnabled = true
        lblMenu.addGestureRecognizer(menuTap)
    }
    
    func onTapMenu(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: {})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
