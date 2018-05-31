//
//  ViewController.swift
//  EcoCap
//
//  Created by Renan Bronchart on 25/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignInViewController: UIViewController {
    var ref: DocumentReference? = nil
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        
        if let email = emailTextField.text, let name = nameTextField.text, let password = passwordTextField.text, let repeatPassword = repeatPasswordTextField.text {
            if password == repeatPassword {
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    if let _ = error {
                        self.showAlert(title: "Error", message: "An error occured during sign in.")
                    } else if let _ = user {
                        let db = Firestore.firestore()
                        self.ref = db.collection("user_detail").addDocument(data: ["name": name, "uid": user?.user.uid])
                        user?.user.sendEmailVerification(completion: { (error) in
                            print("error")
                        })
                        self.performSegue(withIdentifier: "registerSuccess", sender: self)
                    }
                })
            } else {
                self.showAlert(title: "Error", message: "Both password are not identical")
            }
        }
    }
    
    // Display an alert
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true);
    }
}

