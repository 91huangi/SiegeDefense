//
//  Utils.swift
//  SiegeDefense
//
//  Created by Ivan Huang on 2/19/18.
//  Copyright © 2018 Ivan Huang. All rights reserved.
//

import Foundation
import SpriteKit

class Utils {
    
    let pi = CGFloat(3.1415926535897)
    
    init() {
        
    }
    
    func distance(p1: CGPoint, p2: CGPoint) -> CGFloat {
        return CGFloat(hypotf(Float(p2.x-p1.x), Float(p2.y-p1.y)))
    }
    
    // arctan with values in [0, 2*pi)
    func arctan(opp: CGFloat, adj: CGFloat) -> CGFloat {
        var arctan = atan(opp/adj)
        if(opp >= 0 && adj >= 0) {
            return arctan
        } else if (opp < 0 && adj >= 0) {
            return arctan + 2*pi
        } else if (opp >= 0 && adj < 0) {
            return pi+arctan
        } else if (opp < 0 && adj < 0) {
            return pi+arctan
        }
        return CGFloat(0)
    }
}
