//
//  File.swift
//  FieldMargin
//
//  Created by Carla on 2017/08/13.
//  Copyright © 2017 Carla. All rights reserved.
//

import Foundation
import UIKit

public enum Health {
    case ShortCircuited
    case StillFunctioning
}

struct Robot {
    var position : CGPoint
    var bagCount: Int = 0
    var health : Health = .StillFunctioning
    
    init(position: CGPoint) {
        self.position = position
    }
}
