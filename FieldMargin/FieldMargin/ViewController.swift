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
        
        let reloadCallback : () -> () = { [weak self] in
            self?.reload()
        }
        
        self.viewModel = HomeViewModel(reloadCallback: reloadCallback)
        self.listOfInstructions.autocapitalizationType = .allCharacters
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        setupView()
    }
    
    @IBAction func viewLogButtonTapped(_ sender: Any) {
        self.showModal()
    }
    
    func showModal() {
//        let bundle = Bundle(for: type(of: self))
//        let VC = LogViewController(nibName: "LogViewController", bundle: bundle, viewModel: (self.viewModel?.nextViewModel())!)
        let viewModel = self.viewModel?.nextViewModel()
        let VC = LoggerViewController(viewModel: viewModel!)
        VC.modalPresentationStyle = .overCurrentContext
        present(VC, animated: true, completion: nil)
    }
    
    @IBAction func intrustructionsHelpButtonHelped(_ sender: Any) {
        
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        processData()
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            switch textField {
            case beltCoordinates_x:
                return self.filterDisallowedLetters(allowedLetters: "0123456789", string: string)
            case beltCoordinates_y:
                return self.filterDisallowedLetters(allowedLetters: "0123456789", string: string)
            case robotStartCoordinates_x:
                return self.filterDisallowedLetters(allowedLetters: "0123456789", string: string)
            case robotStartCoordinates_y:
                return self.filterDisallowedLetters(allowedLetters: "0123456789", string: string)
            case listOfCrates:
                return self.filterDisallowedLetters(allowedLetters: "0123456789(), ", string: string)
            case listOfInstructions:
                return self.filterDisallowedLetters(allowedLetters: "PDNSEW", string: string)
            default:
                beltCoordinates_x.resignFirstResponder()
        }
        
        return false
    }
    
    func filterDisallowedLetters(allowedLetters: String, string: String) -> Bool{
        let aSet = NSCharacterSet(charactersIn:allowedLetters).inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let filtered = compSepByCharInSet.joined(separator: "")
        return string == filtered
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        findNextResponder(textField: textField)
//    }
    
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
        var (valid, message) : (Bool, String?) = (true, nil)
        switch textField {
        case listOfInstructions:
            (valid, message) = self.viewModel!.validateInstructions(text: text!)
            self.updateValidationLabel(listOfInstructionsValidation, text: message, isHidden: valid)
        case listOfCrates:
            (valid, message) = self.viewModel!.validateCrates(text: text!)
            self.updateValidationLabel(listOfCratesValidation, text: message, isHidden: valid)
        case robotStartCoordinates_x, robotStartCoordinates_y:
            (valid, message) = self.viewModel!.validateCoordinates(text_x: robotStartCoordinates_x.text, text_y: robotStartCoordinates_y.text)
            updateValidationLabel(robotStartCoordinatesValidation, text: message, isHidden: valid)
        case beltCoordinates_x, beltCoordinates_y:
            (valid, message) = self.viewModel!.validateCoordinates(text_x: beltCoordinates_x.text, text_y: beltCoordinates_y.text)
            self.updateValidationLabel(beltCoordinatesValidation, text: message, isHidden: valid)
        default:
            break
        }
        
        
        return valid
    }
    
    func validateAllFields() -> Bool {
        var valid = true
        for case let textField as UITextField in self.view.subviews {
            if !validate(textField) {
                valid = false
            }
        }
        
        return valid
    }
    
    func processData() {
        
        if validateAllFields() {
            self.viewModel!.processFormData(robotCoord_x: self.robotStartCoordinates_x.text!,
                                            robotCoord_y: self.robotStartCoordinates_y.text!,
                                            beltCoord_x: self.beltCoordinates_x.text!,
                                            beltCoord_y: self.beltCoordinates_y.text!,
                                            crates: self.listOfCrates.text!,
                                            instructions: self.listOfInstructions.text!)
            
        }
    }
    
    func reload() {
        self.finalHealthStatus.text = self.viewModel?.finalHealthStatus
        self.finalBagCount.text = self.viewModel?.finalBagCount
        self.finalRobotPosition.text = self.viewModel?.finalRobotPosition
    }
    
    func dismissKeyboard() {
        view.endEditing(true)

    }
    
}
