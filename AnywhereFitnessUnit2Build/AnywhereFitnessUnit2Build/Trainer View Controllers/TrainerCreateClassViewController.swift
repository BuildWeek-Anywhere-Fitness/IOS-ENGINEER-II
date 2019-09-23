//
//  TainerCreateClassViewController.swift
//  AnywhereFitness
//
//  Created by Alex Rhodes on 9/22/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import UIKit

class TrainerCreateClassViewController: UIViewController {

    @IBOutlet weak var classNameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var intensityTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        
    }
}
