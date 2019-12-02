//
//  LoginViewController.swift
//  HateLines
//
//  Created by Mohammad Salamat on 2019-12-01.
//  Copyright © 2019 Rys Rabang. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }

    @IBAction func loginTapped(_ sender: Any) {
        
        // TODO: Validate textfields
        
        // Create cleaned versions of the text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Sign in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            if err != nil {
                // Could not sign in
                self.errorLabel.text = err!.localizedDescription
                self.errorLabel.alpha = 1
                print(err!)
            } else {
                self.transitionToTabBar()
            }
        }
    }
    
    func setUpElements() {
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }
    
    func transitionToTabBar() {
        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.tabBarController)
        
        self.view.window?.rootViewController = tabBarController
        self.view.window?.makeKeyAndVisible()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.landingViewController)
        
        self.view.window?.rootViewController = viewController
        self.view.window?.makeKeyAndVisible()
    }
}
