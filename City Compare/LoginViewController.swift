//
//  LoginViewController.swift
//  City Compare
//
//  Created by Jacob Hendrich on 2/15/21.
//

import Foundation
import Firebase
import Rosefire
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let showListSegueIdentifier = "ShowListSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            print("Someone is already signed in")
            self.performSegue(withIdentifier: self.showListSegueIdentifier, sender: self)
        }
    }
    
    @IBAction func pressedSignInNewUser(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error creating a new user for Email/Pasword \(error)")
                return
            }
            self.performSegue(withIdentifier: self.showListSegueIdentifier, sender: self)
        }
    }
    
    @IBAction func pressedLogInExistingUser(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error logging in existing user for Email/Pasword \(error)")
                return
            }
            self.performSegue(withIdentifier: self.showListSegueIdentifier, sender: self)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showListSegueIdentifier {
            print("Checking for user \(Auth.auth().currentUser!.uid)")
            UserManager.shared.addNewUserMaybe(uid: Auth.auth().currentUser!.uid, name: Auth.auth().currentUser!.displayName,
                                               photoUrl: Auth.auth().currentUser!.photoURL?.absoluteString)
        }
    }
}
