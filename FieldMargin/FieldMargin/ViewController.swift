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

    @IBOutlet weak var robotStartCoordinates_x: UITextField!
    @IBOutlet weak var robotStartCoordinates_y: UITextField!

    @IBOutlet weak var listOfCrates: UITextField!

    @IBOutlet weak var listOfInstructions: UITextField!    
    
    @IBOutlet weak var finalHealthStatus: UILabel!
    @IBOutlet weak var finalBagCount: UILabel!
    @IBOutlet weak var finalRobotPosition: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func viewLogButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func intrustructionsHelpButtonHelped(_ sender: Any) {
        
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
        
        return true    }
    
}
