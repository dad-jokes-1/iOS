//
//  SignUpViewController.swift
//  DadJokes
//
//  Created by John Kouris on 12/18/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(usernameTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !email.isEmpty,
            !password.isEmpty else {
                self.presentDJAlertOnMainThread(title: "Error Signing Up", message: "Please provide your email address and a password before trying to sign up.", buttonTitle: "Ok")
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .invalidEmail:
                        self.presentDJAlertOnMainThread(title: "Error Signing Up", message: "The email you entered is not valid. Please try again.", buttonTitle: "Ok")
                    case .emailAlreadyInUse:
                        self.presentDJAlertOnMainThread(title: "Error Signing Up", message: "The email you entered is already in use. Please use a different email address.", buttonTitle: "Ok")
                        self.emailTextField.text = ""
                    default:
                        self.presentDJAlertOnMainThread(title: "Error Signing Up", message: "There was an issue trying to sign up. Please try again.", buttonTitle: "Ok")
                    }
                }
            } else {
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    if error == nil {
                        let privateJokesController = self.storyboard?.instantiateViewController(withIdentifier: "PrivateJokesVC") as! PrivateJokesTableViewController
                        self.navigationController?.pushViewController(privateJokesController, animated: true)
                        self.view.window?.makeKeyAndVisible()
                    }
                }
            }
        }
    }

}
