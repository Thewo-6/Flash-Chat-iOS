//
//  RegisterViewController.swift
//  Flash Chat IOS
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let e = error as NSError? {
                    let message: String
                    if let code = AuthErrorCode(_bridgedNSError: e)?.code {
                        switch code {
                        case .invalidEmail:
                            message = "The email address is badly formatted. Please check and try again."
                        case .emailAlreadyInUse:
                            message = "This email is already in use. Try signing in or use a different email."
                        case .weakPassword:
                            message = "Your password is too weak. Please use at least 6 characters."
                        case .networkError:
                            message = "A network error occurred. Please check your connection and try again."
                        case .operationNotAllowed:
                            message = "Email/password accounts are not enabled for this project."
                        default:
                            message = e.localizedDescription
                        }
                    } else {
                        message = e.localizedDescription
                    }

                    DispatchQueue.main.async {
                        self.presentErrorAlert(message: message)
                    }
                } else {
                    //Navigate to the ChatViewController
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
                
            }
        }
    }
    
    private func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: "Registration Failed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
