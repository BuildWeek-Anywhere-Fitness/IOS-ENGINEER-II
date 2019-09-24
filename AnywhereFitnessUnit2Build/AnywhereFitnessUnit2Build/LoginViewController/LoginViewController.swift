//
//  LoginViewController.swift
//  AnywhereFitnessUnit2Build
//
//  Created by Alex Rhodes on 9/24/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let segue = UIStoryboardSegue(identifier: "ClientLoginSegue", source: self, destination: ClientViewController())
            
            performSegue(withIdentifier: "ClientLoginSegue", sender: self)
            
        } else  if segmentedControl.selectedSegmentIndex == 1 {
            let segue = UIStoryboardSegue(identifier: "TrainerLoginSegue", source: self, destination: ClientViewController())
            
            performSegue(withIdentifier: "TrainerLoginSegue", sender: self)
        }
        
    }
    
}
