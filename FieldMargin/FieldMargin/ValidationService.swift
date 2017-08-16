//
//  ValidationService.swift
//  FieldMargin
//
//  Created by Carla on 2017/08/16.
//  Copyright © 2017 Carla. All rights reserved.
//

import Foundation

enum ValidationType : String {
    case coordinate = "-0123456789"
    case crate = "-0123456789,() "
    case instruction = "PDNSEW "
}

struct ValidationService {
    //MARK: Validation
    
    func validateText(type: ValidationType, textToValidate: [String?]) -> (Bool, String?){
        for text in textToValidate {
            if text == nil || text == "" {
                return (false, "This field cannot be empty.")
            }
            
            if (!self.stringContainsAllowedLetters(type: type, string: text!)) {
                return (false, "String contains unexpected characters")
            }
        }
        
        switch type {
        case .coordinate:
            return self.validateCoordinates(text_x: textToValidate[0]!, text_y: textToValidate[1]!)
        case .crate:
            return self.validateCrates(text: textToValidate[0]!)
        default:
            return self.validateInstructions(text: textToValidate[0]!)
        }
    }
    
    
    //MARK: Crates
    func validateCrates(text: String) -> (Bool, String?) {
        let text = text.trimmingCharacters(in: .whitespaces)
        
        let cratesAsStrings = text.components(separatedBy: "),")
        for var crateString in cratesAsStrings {
            crateString = crateString.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
            let crateParts = crateString.components(separatedBy: ",")
            if (crateParts.count != 3 || crateParts[0] == "" || crateParts[1] == "" || crateParts[2] == "") {
                return (false, "Unexpected input")
            }
        }
        
        return (text.characters.count > 0, "This field cannot be empty.")
    }
    
    
    //MARK: Instructions
    func validateInstructions(text: String) -> (Bool, String?) {
        let text = text.trimmingCharacters(in: .whitespaces)
        return (text.characters.count > 0, "This field cannot be empty.")
    }
    
    //MARK: Coordinates
    func validateCoordinates(text_x: String, text_y: String) -> (Bool, String?) {
        let chars_x : Int = text_x.characters.count
        let chars_y : Int = text_y.characters.count
        
        return (chars_x > 0 && chars_y > 0, "This field cannot be empty.")
    }
    
    
    
    //MARK: - Helpers
    func stringContainsAllowedLetters(type: ValidationType, string: String) -> Bool{
        let allowedLetters = type.rawValue
        
        let aSet = NSCharacterSet(charactersIn:allowedLetters).inverted
        
        let compSepByCharInSet = string.components(separatedBy: aSet)
        
        let filtered = compSepByCharInSet.joined(separator: "")
        
        let containsDisallowedLetters = string == filtered

        return containsDisallowedLetters
    }
    
}
