//
//  LoggerViewController.swift
//  FieldMargin
//
//  Created by Carla on 2017/08/15.
//  Copyright © 2017 Carla. All rights reserved.
//

import Foundation
import UIKit

class LoggerViewController : UIViewController {
    
    @IBOutlet weak var loggerTextView: UITextView!
    var viewModel : LogViewModel?
    
    init(viewModel: LogViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loggerTextView.text = self.viewModel?.displayLogs()
    }
}
