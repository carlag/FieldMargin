//
//  RobotService.swift
//  FieldMargin
//
//  Created by Carla on 2017/08/15.
//  Copyright © 2017 Carla. All rights reserved.
//

import Foundation
import UIKit

typealias FinalState = (String, String, String)

protocol RobotServiceProtocol {
    init(robot: Robot, belt: Belt, crates: [Crate], instructions: [Instruction])
    mutating func startRobot() -> FinalState
}


struct RobotService : RobotServiceProtocol {
    var logger: [String] = []
    var robot : Robot?
    var belt : Belt?
    var crates: [Crate] = []
    var commands : [Instruction] = []
    
    init(robot: Robot, belt: Belt, crates: [Crate], instructions: [Instruction]) {
        self.robot = robot
        self.belt = belt
        self.crates = crates
        self.commands = instructions
    }
    
    mutating func startRobot() -> FinalState {
        while (self.robot?.health != .ShortCircuited && self.commands.count > 0) {
            let nextCommand = self.commands.remove(at: 0)
            processCommand(command: nextCommand)
        }
        
        let finalPosition = "(\(self.robot!.position.x),\(self.robot!.position.y))"
        return (self.robot!.health.rawValue, String(self.belt!.bagCount), finalPosition)
    }
    
    mutating func processCommand(command: Instruction) {
        logger.append("Instruction: \(command)")
        switch command {
        case Instruction.Drop:
            dropABag()
            break
        case Instruction.Pickup:
            pickupABag()
            break
        case Instruction.North, Instruction.South, Instruction.East, Instruction.West:
            move(direction: command)
            break
        default:
            break
        }
    }
    
    mutating func dropABag() {
        
        guard robot != nil else {return}
        guard belt != nil else {return}
        
        if (self.robot!.position == self.belt!.position) {
            if (self.robot!.bagCount > 0) {
                self.belt!.bagCount += self.robot!.bagCount
                
                logger.append("Robot dropped \(self.robot!.bagCount) bags")
                self.robot!.bagCount = 0
                logger.append("Conveyer belt now has \(self.belt!.bagCount) bags")
                
            } else {
                logger.append("Robot had nothing to drop")
            }
        } else {
            robot?.health = .ShortCircuited
        }
    }
    
    mutating func pickupABag() {
        
        guard robot != nil else {return}
        
        let findPosition = self.robot!.position
        
        if let i = crates.index(where: { $0.position == findPosition }) {
            logger.append("Pick up bags at \(findPosition)")
            if (crates[i].quantity > 0) {
                self.robot?.bagCount += 1
                crates[i].quantity -= 1
            } else {
                logger.append("Crate is empty")
            }
        } else {
            logger.append("No crate at position \(findPosition)")
            robot?.health = .ShortCircuited
        }
    }
    
    mutating func move(direction: Instruction) {
        guard robot != nil else {return}
        
        var x_pos = robot!.position.x
        var y_pos = robot!.position.y
        
        switch direction {
        case .North:
            y_pos += 1
            break
        case .South:
            y_pos -= 1
            break
        case .East:
            x_pos += 1
            break
        case .West:
            x_pos -= 1
            break
        default:
            break
        }
        
        let pos : CGPoint = CGPoint(x: x_pos, y: y_pos)
        logger.append("New position: \(pos)")
        robot!.position = pos
    }
}
