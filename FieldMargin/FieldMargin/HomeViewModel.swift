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
    func validateText(type: ValidationType, textToValidate: [String?]) -> (Bool, String?)
    func stringContainsAllowedLetters(type: ValidationType, string: String) -> Bool
    func nextViewModel() -> LogViewModel
}

struct HomeViewModel : HomeViewModelProtocol {
    //MARK: Properties
    var robotService : RobotService?
    var validationService : ValidationService?
    var reload : (()->())?
    var finalState : FinalState?
    var finalHealthStatus : String { get { return finalState!.0 }}
    var finalBagCount : String { get { return finalState!.1 }}
    var finalRobotPosition: String { get { return finalState!.2 }}
    
    //MARK: Setup
    init(reloadCallback: @escaping (()->())) {
        self.reload = reloadCallback
        self.robotService = RobotService()
        self.validationService = ValidationService()
    }
    
    //MARK: Public
    mutating func processFormData(robotCoord_x: String, robotCoord_y: String, beltCoord_x: String, beltCoord_y: String, crates: String, instructions: String)
    {
        let robot = Robot(position: CGPoint(x: Int(robotCoord_x)!, y: Int(robotCoord_y)!))
        let belt = Belt(position: CGPoint(x: Int(beltCoord_x)!, y: Int(beltCoord_y)!))

        let crateList = makeCrates(input: crates)
        let instructionsList = makeInstructions(input: instructions)

        self.robotService?.robot = robot
        self.robotService?.belt = belt
        self.robotService?.crates = crateList
        self.robotService?.commands = instructionsList
        
        let finalState = self.robotService?.startRobot()
        self.finalState = finalState
        
        self.reload!()
    }
    
    func nextViewModel() -> LogViewModel {
        let logViewModel = LogViewModel(logger: self.robotService!.logger)
        return logViewModel
    }
    

}

//MARK: Validation
extension HomeViewModel {
    func validateText(type: ValidationType, textToValidate: [String?]) -> (Bool, String?) {
        guard self.validationService != nil else {return (true, nil)}
        
        return self.validationService!.validateText(type: type, textToValidate: textToValidate)
    }
    
    func stringContainsAllowedLetters(type: ValidationType, string: String) -> Bool {
        guard self.validationService != nil else {return (false)}
        
        return self.validationService!.stringContainsAllowedLetters(type: type, string: string)
    }
}

//MARK: Formating input
extension HomeViewModel {
    
    fileprivate func makeCrates(input: String) -> [Crate] {
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
    
    fileprivate func makeInstructions(input: String) -> [Instruction] {
        let instructions : [Instruction] = input.characters.map {
            return Instruction(rawValue: $0)!
        }
        
        return instructions
    }
}
