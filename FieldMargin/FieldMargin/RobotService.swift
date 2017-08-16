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
    mutating func startRobot() -> FinalState
    func processCommand(command: Instruction)
    func dropABag()
    func pickupABag()
    func move(direction: Instruction)
}


class RobotService : RobotServiceProtocol {
    //MARK: Properties
    var logger: [String] = []
    var robot : Robot?
    var belt : Belt?
    var crates: [Crate] = []
    var commands : [Instruction] = []
    
    
    //MARK: Start
    func startRobot() -> FinalState {
        self.setupLogger()
        while (self.robot?.health != .ShortCircuited && self.commands.count > 0) {
            let nextCommand = self.commands.remove(at: 0)
            processCommand(command: nextCommand)
        }
        
        //finish executing intructions
        return self.getStateAtCompletion()

    }
    
    //MARK: Setup
    func setupLogger() {
        self.logger = []
        logger.append("-----Setup-----")
        logger.append("Robot start: \(self.robot!.position)")
        logger.append("Belt start: \(self.belt!.position)")
        for crate in crates {
            logger.append("\(crate)")
        }
        logger.append(" ")
        logger.append("-----Robot started-----")
        
    }
    
    //MARK: Execute instructions from user input
    func processCommand(command: Instruction) {
        switch command {
        case Instruction.Drop:
            dropABag()
            break
        case Instruction.Pickup:
            pickupABag()
            break
        default:
            move(direction: command)
        }
    }
    
    func getStateAtCompletion() -> FinalState {
        let finalPosition = "(\(self.robot!.position.x),\(self.robot!.position.y))"
        let finalHealth = self.robot!.health.rawValue
        let finalBagCount = String(self.belt!.bagCount)
        return (finalHealth, finalBagCount, finalPosition)
    }
    
    
    //MARK: Instructions
    func dropABag() {
        logger.append("D: DROP BAG")
        guard robot != nil else {return}
        guard belt != nil else {return}
        self.tryDropBag()
    }
    
    func pickupABag() {
        logger.append("P: PICK UP BAG")
        guard robot != nil else {return}
        self.tryPickupABag()
    }
    
    func move(direction: Instruction) {
        guard robot != nil else {return}
        self.tryMove(direction: direction)
    }
}


//MARK: - Instruction Helpers
extension RobotService {
    //DROP
    func tryDropBag() {
        guard self.robot!.bagCount > 0 else {
            logger.append("Robot had nothing to drop")
            return
        }
        
        guard self.robot!.position == self.belt!.position else {
            logger.append("No conveyer belt at position. Robot drops bag on floor. ")
            logger.append("Robot short circuits")
            robot?.health = .ShortCircuited
            return
        }
        
        self.belt!.bagCount += self.robot!.bagCount
        self.robot!.bagCount = 0
        
        logger.append("Robot dropped its bag")
        logger.append("Conveyer belt now has \(self.belt!.bagCount) bags")
    }
    
    //PICK UP
    func tryPickupABag() {
        
        let findPosition = self.robot!.position
        
        if let i = crates.index(where: { $0.position == findPosition }) {
            if (self.robot?.bagCount == 1) {
                logger.append("Robot already has a bag. Can't pick up another")
            }
            else if (crates[i].quantity > 0) {
                self.robot?.bagCount += 1
                crates[i].quantity -= 1
                logger.append("Pick up bags at \(findPosition)")
            } else {
                logger.append("Crate is empty")
            }
        } else {
            logger.append("No crate at position \(findPosition)")
            logger.append("Robot short circuits.")
            robot?.health = .ShortCircuited
        }
    }
    
    //MOVE
    func tryMove(direction: Instruction) {
        
        var x_pos = robot!.position.x
        var y_pos = robot!.position.y
        switch direction {
        case .North:
            logger.append("N: MOVE NORTH")
            y_pos += 1
            break
        case .South:
            logger.append("S: MOVE SOUTH")
            y_pos -= 1
            break
        case .East:
            logger.append("E: MOVE EAST")
            x_pos += 1
            break
        case .West:
            logger.append("W: MOVE WEST")
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
