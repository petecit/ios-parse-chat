//
//  ViewController.swift
//  ios-parse-chat
//
//  Created by peter on 12/7/18.
//  Copyright © 2018 petecit. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func clickSignUpButton(_ sender: Any) {
        registerUser()
    }
    
    @IBAction func clickLoginButton(_ sender: Any) {
        loginUser()
    }
    
    func registerUser() {
        // initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.username = usernameTextField.text
        newUser.password = passwordTextField.text
        
        // call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                self.displaySignupErrorAlert()
            }
            else {
                // display view controller after successful login
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    func loginUser() {
        
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
                self.displayLoginErrorAlert()
            } else {
                print("User logged in successfully")
                
                // display view controller that needs to shown after successful login
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    /*---display alert methods---*/
    
    // This function is called whenever the sign-in credentials are incorrect. or whenever
    // the sign-up credentials are duplicate, i.e., the user already exists
    func displayLoginErrorAlert() {
        // Customize the look and text of the alert controller
        let alertController = UIAlertController(title: "Login Failed!", message: "Please enter a valid username and password combination.", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Try Again", style: .default)
        alertController.addAction(dismissAction)
        // Present the alert and run code to clear the fields in the completing block
        present(alertController, animated: true) {
            self.usernameTextField.text = ""
            self.passwordTextField.text = ""
        }
    }
    
    // This function is called whenever the sign-up credentials are duplicate, i.e.,
    // the user already exists in the database
    func displaySignupErrorAlert() {
        // Customize the look and text of the alert controller
        let alertController = UIAlertController(title: "Signup Failed!", message: "That username is already taken. Please choose another one.", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Try Again", style: .default)
        alertController.addAction(dismissAction)
        // Present the alert and run code to clear the fields in the completion block
        present(alertController, animated: true) {
            self.usernameTextField.text = ""
            self.passwordTextField.text = ""
        }
    }
    
    // The function is called when the user signs-up successfully
    func displaySignupSuccessAlert() {
        // Customize the look and text of the alert controller
        let alertController = UIAlertController(title: "Signup Successful!", message: "New account created.", preferredStyle: .alert)
        // Allow the modal segue to occur when the alert is dismissed
        let dismissAction = UIAlertAction(title: "Continue", style: .default) { (action) in
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
        // Present the alert to the user
        alertController.addAction(dismissAction)
        present(alertController, animated: true) { }
    }
    
}

