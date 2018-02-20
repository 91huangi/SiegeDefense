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
    
    func arctan(r: CGFloat) -> CGFloat {
        var arctan = atan(r)
        return min(arctan, arctan+2*pi)
    }
}
