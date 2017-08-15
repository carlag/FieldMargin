//
//  ViewController.swift
//  FieldMargin
//
//  Created by Carla on 2017/08/13.
//  Copyright © 2017 Carla. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var beltCoordinates_x: UITextField!
    @IBOutlet weak var beltCoordinates_y: UITextField!
    @IBOutlet weak var beltCoordinatesValidation: UILabel!
    
    @IBOutlet weak var robotStartCoordinates_x: UITextField!
    @IBOutlet weak var robotStartCoordinates_y: UITextField!
    @IBOutlet weak var robotStartCoordinatesValidation: UILabel!
    
    @IBOutlet weak var listOfCrates: UITextField!
    @IBOutlet weak var listOfCratesValidation: UILabel!
    
    @IBOutlet weak var listOfInstructionsValidation: UILabel!
    @IBOutlet weak var listOfInstructions: UITextField!
    
    @IBOutlet weak var finalHealthStatus: UILabel!
    @IBOutlet weak var finalBagCount: UILabel!
    @IBOutlet weak var finalRobotPosition: UILabel!
    
    var viewModel : HomeViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup View
        self.viewModel = HomeViewModel()
        
        setupView()
    }
    
    @IBAction func viewLogButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func intrustructionsHelpButtonHelped(_ sender: Any) {
        
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        // Validate Text Field
        let validInstructions = validate(self.listOfInstructions)
        let validCrates = validate(self.listOfCrates)
        
        if validInstructions && validCrates {
            //update
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - View Methods
    
    fileprivate func setupView() {
        listOfCratesValidation.isHidden = true
        listOfInstructionsValidation.isHidden = true
        robotStartCoordinatesValidation.isHidden = true
        beltCoordinatesValidation.isHidden = true
    }
}


extension ViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        findNextResponder(textField: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        findNextResponder(textField: textField)
        return true

    }
    
    // MARK: - Helper Methods
    func updateValidationLabel(_ label: UILabel, text: String?, isHidden: Bool) {
        label.text = text
        UIView.animate(withDuration: 0.25, animations: {
            label.isHidden = isHidden
        })
    }
    
    fileprivate func findNextResponder(textField: UITextField) {
        if(validate(textField)) {
            switch textField {
            case beltCoordinates_x:
                beltCoordinates_y.becomeFirstResponder()
            case beltCoordinates_y:
                robotStartCoordinates_x.becomeFirstResponder()
            case robotStartCoordinates_x:
                robotStartCoordinates_y.becomeFirstResponder()
            case robotStartCoordinates_y:
                listOfCrates.becomeFirstResponder()
            case listOfCrates:
                listOfInstructions.becomeFirstResponder()
            default:
                beltCoordinates_x.resignFirstResponder()
            }
        }
    }
    
    fileprivate func validate(_ textField: UITextField) -> Bool {
        let text = textField.text
        switch textField {
        case listOfInstructions:
            let (valid, message) = self.viewModel!.validateInstructions(text: text!)
            self.updateValidationLabel(listOfInstructionsValidation, text: message, isHidden: valid)
        case listOfCrates:
            let (valid, message) = self.viewModel!.validateCrates(text: text!)
            self.updateValidationLabel(listOfCratesValidation, text: message, isHidden: valid)
        case robotStartCoordinates_x, robotStartCoordinates_y:
            let (valid, message) = self.viewModel!.validateCoordinates(text_x: robotStartCoordinates_x.text, text_y: robotStartCoordinates_y.text)
            self.updateValidationLabel(robotStartCoordinatesValidation, text: message, isHidden: valid)
        case beltCoordinates_x, beltCoordinates_y:
            let (valid, message) = self.viewModel!.validateCoordinates(text_x: beltCoordinates_x.text, text_y: beltCoordinates_y.text)
            self.updateValidationLabel(beltCoordinatesValidation, text: message, isHidden: valid)
        default:
            break
        }
        

        return true
    }
    

    
    
}
