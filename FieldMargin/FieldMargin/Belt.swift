//
//  ConveyorBelt.swift
//  FieldMargin
//
//  Created by Carla on 2017/08/13.
//  Copyright © 2017 Carla. All rights reserved.
//

import Foundation
import UIKit

struct Belt {
    var position : CGPoint
    var bagCount : Int = 0
    
    init(position: CGPoint) {
        self.position = position
    }
}
