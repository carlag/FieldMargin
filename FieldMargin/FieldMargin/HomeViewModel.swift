//
//  HomeViewModel.swift
//  FieldMargin
//
//  Created by Carla on 2017/08/15.
//  Copyright © 2017 Carla. All rights reserved.
//

import Foundation
import UIKit

protocol HomeViewModelProtocol {
    mutating func processFormData(robotCoord_x: String, robotCoord_y: String, beltCoord_x: String, beltCoord_y: String, crates: String, instructions: String)
    func validateInstructions(text: String?) -> (Bool, String?)
    func validateCrates(text: String?) -> (Bool, String?)
}

struct HomeViewModel : HomeViewModelProtocol {

    
    var reload : (()->())?
    
    var finalState : FinalState?
    var finalHealthStatus : String { get { return finalState!.0 }}
    var finalBagCount : String { get { return finalState!.1 }}
    var finalRobotPosition: String { get { return finalState!.2 }}
    
    init(reloadCallback: @escaping (()->())) {
        self.reload = reloadCallback
    }
    
    
    mutating func processFormData(robotCoord_x: String, robotCoord_y: String, beltCoord_x: String, beltCoord_y: String, crates: String, instructions: String)

    {
        let robot = Robot(position: CGPoint(x: Int(robotCoord_x)!, y: Int(robotCoord_y)!))
        let belt = Belt(position: CGPoint(x: Int(robotCoord_x)!, y: Int(robotCoord_y)!))

        let crateList = makeCrates(input: crates)
        let instructionsList = makeInstructions(input: instructions)

        var robotService = RobotService(robot: robot, belt: belt, crates: crateList, instructions: instructionsList)
        let finalState = robotService.startRobot()
        self.finalState = finalState
        
        self.reload!()
    }
}

//MARK: Validation
extension HomeViewModel {

    func validateCrates(text: String?) -> (Bool, String?) {
        
        guard text != nil else {
            return (false, nil)
        }
        
        let characterset = CharacterSet(charactersIn: "0123456789,()")
        if text!.rangeOfCharacter(from: characterset.inverted) != nil {
            return (false, "String contains unexpected characters")
        }
        
        return (text!.characters.count > 0, "This field cannot be empty.")
    }
    
    func validateInstructions(text: String?) -> (Bool, String?) {
        
        guard text != nil else {
            return (false, nil)
        }
        
        let characterset = CharacterSet(charactersIn: "PDNSEW ")
        if text!.rangeOfCharacter(from: characterset.inverted) != nil {
            return (false, "String contains unexpected characters")
        }
        
        return (text!.characters.count > 0, "This field cannot be empty.")
    }
    
    func validateCoordinates(text_x: String?, text_y: String?) -> (Bool, String?) {
        
        guard text_x != nil && text_y != nil else {
            return (false, nil)
        }
        
        let chars_x : Int = text_x!.characters.count
        let chars_y : Int = text_y!.characters.count
        
        let (valid, message) = (chars_x > 0 && chars_y > 0, "This field cannot be empty.")
        
        
        return  (valid, message)   }

}

//MARK: Formating input
extension HomeViewModel {
    
    func makeCrates(input: String) -> [Crate] {
        let input = input.trimmingCharacters(in: .whitespaces)
        let cratesAsStrings = input.components(separatedBy: "),")
        
        let crates : [Crate] = cratesAsStrings.map {
            let crateAsString = $0.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
            let crateAsArray = crateAsString.components(separatedBy: ",").map { Int($0)}
            let crate = Crate(position: CGPoint(x: crateAsArray[0]!, y: crateAsArray[1]!), quantity: crateAsArray[2]!)
            return crate
        }

        return crates
    }
    
    func makeInstructions(input: String) -> [Instruction] {
        let instructions : [Instruction] = input.characters.map {
            return Instruction(rawValue: $0)!
        }
        
        return instructions
    }
}
