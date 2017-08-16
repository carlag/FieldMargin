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
    var keyboarDismissed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupView()
    }
    
    
    // MARK: - View Methods
    fileprivate func setupView() {
        listOfCratesValidation.isHidden = true
        listOfInstructionsValidation.isHidden = true
        robotStartCoordinatesValidation.isHidden = true
        beltCoordinatesValidation.isHidden = true
        self.listOfInstructions.autocapitalizationType = .allCharacters
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    fileprivate func setupViewModel() {
        let reloadCallback : () -> () = { [weak self] in
            self?.reload()
        }
        self.viewModel = HomeViewModel(reloadCallback: reloadCallback)
    }
    
    fileprivate func reload() {
        self.finalHealthStatus.text = self.viewModel?.finalHealthStatus
        self.finalBagCount.text = self.viewModel?.finalBagCount
        self.finalRobotPosition.text = self.viewModel?.finalRobotPosition
    }
}


//MARK:-  Actions
extension ViewController {
    @IBAction func viewLogButtonTapped(_ sender: Any) {
        self.showModal()
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        self.keyboarDismissed = true
        view.endEditing(true)

        processData()
    }
    
    fileprivate func showModal() {
        let viewModel = self.viewModel?.nextViewModel()
        let viewController = LoggerViewController(viewModel: viewModel!)
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: true, completion: nil)
    }
    
    fileprivate func processData() {
        
        if validateAllFields() {
            self.viewModel!.processFormData(robotCoord_x: self.robotStartCoordinates_x.text!,
                                            robotCoord_y: self.robotStartCoordinates_y.text!,
                                            beltCoord_x: self.beltCoordinates_x.text!,
                                            beltCoord_y: self.beltCoordinates_y.text!,
                                            crates: self.listOfCrates.text!,
                                            instructions: self.listOfInstructions.text!)
            
        }
    }
}

//MARK: - Text Field Delegate Methods
extension ViewController: UITextFieldDelegate {
    
    func dismissKeyboard() {
        self.keyboarDismissed = true
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        findNextResponder(textField: textField)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case beltCoordinates_x, beltCoordinates_y, robotStartCoordinates_x, robotStartCoordinates_y:
            return self.viewModel!.stringContainsAllowedLetters(type: .coordinate, string: string)
        case listOfCrates:
            return self.viewModel!.stringContainsAllowedLetters(type: .crate, string: string)
        case listOfInstructions:
            return self.viewModel!.stringContainsAllowedLetters(type: .instruction, string:string)
        default:
            beltCoordinates_x.resignFirstResponder()
        }
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        findNextResponder(textField: textField)
    }
    
    // MARK:  Validation Helper Methods
    func validateAllFields() -> Bool {
        var valid = true
        for case let textField as UITextField in self.view.subviews {
            if !validate(textField) {
                valid = false
            }
        }
        
        return valid
    }
    
    func updateValidationLabel(_ label: UILabel, text: String?, isHidden: Bool) {
        label.text = text
        UIView.animate(withDuration: 0.25, animations: {
            label.isHidden = isHidden
        })
    }
    
    fileprivate func validate(_ textField: UITextField) -> Bool {
        let text = textField.text
        var (valid, message) : (Bool, String?) = (true, nil)
        switch textField {
        case listOfInstructions:
            (valid, message) = self.viewModel!.validateText(type: .instruction, textToValidate: [text])
            self.updateValidationLabel(listOfInstructionsValidation, text: message, isHidden: valid)
        case listOfCrates:
            (valid, message) = self.viewModel!.validateText(type: .crate, textToValidate: [text])
            self.updateValidationLabel(listOfCratesValidation, text: message, isHidden: valid)
        case robotStartCoordinates_x, robotStartCoordinates_y:
            (valid, message) = self.viewModel!.validateText(type: .coordinate, textToValidate: [robotStartCoordinates_x.text, robotStartCoordinates_y.text])
            updateValidationLabel(robotStartCoordinatesValidation, text: message, isHidden: valid)
        case beltCoordinates_x, beltCoordinates_y:
            (valid, message) = self.viewModel!.validateText(type: .coordinate, textToValidate: [beltCoordinates_x.text, beltCoordinates_y.text])
            self.updateValidationLabel(beltCoordinatesValidation, text: message, isHidden: valid)
        default:
            break
        }
        
        return valid
    }
    
    fileprivate func findNextResponder(textField: UITextField) {
        if (self.keyboarDismissed) {
            self.keyboarDismissed = false
            return
        }
        
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
            if(validate(textField)) {
                listOfInstructions.becomeFirstResponder()
            }
        case listOfInstructions:
            if (validate(textField)) {
                view.endEditing(true)
            }
        default:
            view.endEditing(true)
        }
    }
}
