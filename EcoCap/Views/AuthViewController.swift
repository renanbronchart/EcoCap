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

class AuthViewController: UIViewController {
    var ref: DocumentReference? = nil
    
    // Register
    @IBOutlet weak var signinEmailTextField: UITextField!
    @IBOutlet weak var signinNameTextField: UITextField!
    @IBOutlet weak var signinPasswordTextField: UITextField!
    @IBOutlet weak var signinRepeatPasswordTextField: UITextField!
    @IBOutlet weak var signinRegisterButton: UIButton!
    @IBOutlet weak var signInBackLoginButton: UIButton!
    
    // Login
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginCreateAccountButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: "USERLOGGEDIN") == true {
            print("CONNECTED")
            var homeStoryboard: UIStoryboard!
            homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
            if let challengesViewcontroller = homeStoryboard.instantiateViewController(withIdentifier: "challengesViewControllerIdentifier") as? ChallengesViewController {
                self.present(challengesViewcontroller, animated: true, completion: nil)
            }
            
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // Handle registering with firebase and
    // create a new user detail.
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        if let email = signinEmailTextField.text, let name = signinNameTextField.text, let password = signinPasswordTextField.text, let repeatPassword = signinRepeatPasswordTextField.text {
            if password == repeatPassword {
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    if let _ = error {
                        self.showAlert(title: "Error", message: "An error occured during sign in.")
                    } else if let _ = user {
                        let db = Firestore.firestore()
                        let settings = db.settings
                        settings.areTimestampsInSnapshotsEnabled = true
                        db.settings = settings
                        self.ref = db.collection("user_detail").addDocument(data: ["name": name, "uid": user?.user.uid as Any])
                        user?.user.sendEmailVerification(completion: { (error) in
                            print("error")
                        })
                        var homeStoryboard: UIStoryboard!
                        homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
                        if let challengesViewcontroller = homeStoryboard.instantiateViewController(withIdentifier: "challengesViewControllerIdentifier") as? ChallengesViewController {
                            self.present(challengesViewcontroller, animated: true, completion: nil)
                        }
                    }
                })
            } else {
                self.showAlert(title: "Error", message: "Both password are not identical")
            }
        }
    }
    
    // Handle sign in with Firebase
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if let loginEmail = loginEmailTextField.text, let loginPassword = loginPasswordTextField.text {
            Auth.auth().signIn(withEmail: loginEmail, password: loginPassword) { (data, error) in
                if let _ = error {
                    self.showAlert(title: "Error", message: "An error occured during sign in.")
                } else if let _ = data {
                    print("caca")
                    UserDefaults.standard.set(true, forKey: "USERLOGGEDIN")
                    print(UserDefaults.standard.bool(forKey: "USERLOGGEDIN"))
                    var homeStoryboard: UIStoryboard!
                    homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
                    if let challengesViewcontroller = homeStoryboard.instantiateViewController(withIdentifier: "challengesViewControllerIdentifier") as? ChallengesViewController {
                        self.present(challengesViewcontroller, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    // Redirect to register view
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        self.showOnCurrentStoryboard(identifier: "registerIdentifier")
    }
    
    // Redirect to login view
    @IBAction func backLoginButtonTapped(_ sender: UIButton) {
        self.showOnCurrentStoryboard(identifier: "loginIdentifier")
    }
    
    // Display an alert
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true);
    }
    
    // Present view on current Storyboard by identifier
    func showOnCurrentStoryboard(identifier: String){
        if let authViewcontroller = self.storyboard?.instantiateViewController(withIdentifier: identifier) as? AuthViewController {
            self.present(authViewcontroller, animated: false, completion: nil)
        }
    }
}

