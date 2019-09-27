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
    @IBOutlet weak var loginRegisterButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var registerLoginLabel: UILabel!
    
    var clientHome = ClientViewController()
    
    var isLogin: Bool = true
    var userController = UserController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        
    }
    
    private func setViews() {
        
        view.backgroundColor = .white
        
        passwordTextField.isSecureTextEntry = true
        loginRegisterButton.setTitle("LOGIN", for: .normal)
        loginRegisterButton.setTitleColor(.white, for: .normal)
        loginRegisterButton.backgroundColor = #colorLiteral(red: 0.1719937623, green: 0.799302876, blue: 0.4432982504, alpha: 1)
        loginRegisterButton.alpha = 0.9
        loginRegisterButton.layer.cornerRadius = 6
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            if isLogin {
                clientLogin()
            } else {
                clientRegister()
            }
            
            
        } else  if segmentedControl.selectedSegmentIndex == 1 {
            if isLogin {
                trainerLogin()
            } else {
                trainerRegister()
            }
        }
        
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        
        isLogin = !isLogin
        
        if isLogin == true {
            loginRegisterButton.setTitle("LOGIN", for: .normal)
            registerLoginLabel.text = "If you have not registered, please click"
        } else {
            loginRegisterButton.setTitle("REGISTER", for: .normal)
            registerLoginLabel.text = "If you would like to login, please click"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TrainerLoginSegue" {
            guard let destination = segue.destination as? TrainerViewController else {return}
            destination.userController = userController
        } else  if segue.identifier == "ClientLoginSegue" {
            guard let destination = segue.destination as? ClientViewController else {return}
            destination.userController = userController
        }
    }
    
    
    // MARK: - Methods
    func trainerLogin() {
        let check = completeFieldsChecker()
        if check == true {
            guard let username = usernameTextField.text,
                !username.isEmpty,
                let email = emailTextField.text,
                !email.isEmpty,
                let password = passwordTextField.text,
                !password.isEmpty else { return }
            
            let user = TrainerRepresentation(email: email, username: username, password: password, instructor: true, identifier: nil)
            userController.trainerLogIn(with: user, loginType: .login, completion: { (result) in
                if (try? result.get()) != nil {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "TrainerLoginSegue", sender: self)
                    }
                } else {
                    NSLog("Error logging in with \(result)")
                }
            })
        } else {
            return
        }
    }
    
    
    func trainerRegister() {
        let check = completeFieldsChecker()
        if check == true {
            guard let username = usernameTextField.text,
                !username.isEmpty,
                let email = emailTextField.text,
                !email.isEmpty,
                let password = passwordTextField.text,
                !password.isEmpty else { return }
            
            let user = TrainerRepresentation(email: email, username: username, password: password, instructor: true, identifier: nil)
            userController.trainerSignUp(with: user, loginType: .register) { (error) in
                if error == error {
                    NSLog("Error registering with \(error)")
                }
                self.userController.trainerLogIn(with: user, loginType: .login) { (result) in
                    if (try? result.get()) != nil {
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "TrainerLoginSegue", sender: self)
                        }
                    } else {
                        NSLog("Error logging in with \(result)")
                    }
                }
            }
        }
    }
    
    func clientLogin() {
        let check = completeFieldsChecker()
        if check == true {
            guard let username = usernameTextField.text,
                !username.isEmpty,
                let email = emailTextField.text,
                !email.isEmpty,
                let password = passwordTextField.text,
                !password.isEmpty else { return }
            
            let user = ClientRepresentation(email: email, username: username, password: password, instructor: false, identifier: nil)
            userController.clientLogIn(with: user, loginType: .login, completion: { (result) in
                if (try? result.get()) != nil {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "ClientLoginSegue", sender: self)
                    }
                } else {
                    NSLog("Error logging in with \(result)")
                }
            })
        } else {
            return
        }
    }
    
    
    func clientRegister() {
        let check = completeFieldsChecker()
        if check == true {
            guard let username = usernameTextField.text,
                !username.isEmpty,
                let email = emailTextField.text,
                !email.isEmpty,
                let password = passwordTextField.text,
                !password.isEmpty else { return }
            
            let user = ClientRepresentation(email: email, username: username, password: password, instructor: false, identifier: nil)
            userController.clientSignUp(with: user, loginType: .register) { (error) in
                if error == error {
                    NSLog("Error registering with \(error)")
                }
                self.userController.clientLogIn(with: user, loginType: .login) { (result) in
                    if (try? result.get()) != nil {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        NSLog("Error logging in with \(result)")
                    }
                }
            }
        }
    }
    
    func completeFieldsChecker() -> Bool{
        
        let title: String = "Oops!"
        var message: String?
        var checker: Bool = false
        
        if let username = usernameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text {
            if username.isEmpty && isLogin == false {
                message = "Please enter your name."
            } else if email.isEmpty || email.contains("@") == false {
                message = "Please enter a valid email."
            } else if password.isEmpty {
                message = "Please enter your password"
            } else if password.count < 5 {
                message = "Your password must be at least 5 characters long."
            } else {
                checker = true
            }
        }
        
        if checker == false {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        return checker
    }
}

