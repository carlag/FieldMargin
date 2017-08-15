//
//  HomeViewModel.swift
//  FieldMargin
//
//  Created by Carla on 2017/08/15.
//  Copyright © 2017 Carla. All rights reserved.
//

import Foundation

protocol HomeViewModelProtocol {
    func validateInstructions(text: String?) -> (Bool, String?)
    func validateCrates(text: String?) -> (Bool, String?)
}

struct HomeViewModel : HomeViewModelProtocol {
    
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
