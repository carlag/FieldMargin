//
//  TestInput.swift
//  FieldMargin
//
//  Created by Carla on 2017/08/13.
//  Copyright © 2017 Carla. All rights reserved.
//

import Foundation
import UIKit
@testable import FieldMargin

struct TestInput {
    
    struct AllGood {
        
        let robot = Robot(position: CGPoint(x:1, y:0))
        let belt = Belt(position: CGPoint(x:1, y:-3))
        
        let crates = [
            Crate(position: CGPoint(x:0,y:0), quantity: 10),
            Crate(position: CGPoint(x:0,y:-1), quantity: 2),
            Crate(position: CGPoint(x:0,y:-2), quantity: 1),
            ]
        
        let instructions : [Instruction] = [.W, .P, .S, .P, .S, .S, .E, .D]
    }
    
    struct NoCrateAtPosition {
        
    }
    
    struct NoBeltAtPosition {
        
    }
    
    
    struct EmptyCrate {
        
    }
    
    struct RobotHasNoBagsToDrop {
        let robot = Robot(position: CGPoint(x:1, y:1))
        let belt = Belt(position: CGPoint(x:1, y:1))

        
        let instructions : [Instruction] = [.D]
    }
    
    
}

