//
//  ResultsPopupViewModel.swift
//  FieldMargin
//
//  Created by Carla on 2017/08/13.
//  Copyright © 2017 Carla. All rights reserved.
//

import Foundation
import UIKit

typealias Logger = [String]

protocol LogViewModelProtocol {
    func displayLogs() -> String
}

struct LogViewModel: LogViewModelProtocol {
    
    var logger : Logger?
    
    init(logger: Logger) {
        self.logger = logger
    }
    
    func displayLogs() -> String {
        let all = logger?.joined(separator: "\n")
        return all!
    }
}
