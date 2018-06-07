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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "USERLOGGEDIN") == true {
            print("CONNECTED")
            self.redirectToChallengeViewStoryboard()

        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // Handle registering with firebase and
    // create a new user detail.
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        if let email = signinEmailTextField.text, let name = signinNameTextField.text, let password = signinPasswordTextField.text, let repeatPassword = signinRepeatPasswordTextField.text {
            if password == repeatPassword {
                self.initUser(email: email, name: name, password: password, repeatPassword: repeatPassword)
            } else {
                self.showAlert(title: "Error", message: "Both password are not identical")
            }
        }
    }
    
    // Handle sign in with Firebase
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        if let loginEmail = loginEmailTextField.text, let loginPassword = loginPasswordTextField.text {
            Auth.auth().signIn(withEmail: loginEmail, password: loginPassword) { (data, error) in
                if let error = error {
                    print("\(error.localizedDescription)")
                    self.showAlert(title: "Error", message: "An error occured during sign in.")
                } else if let _ = data {
                    UserDefaults.standard.set(true, forKey: "USERLOGGEDIN")
                    print(UserDefaults.standard.bool(forKey: "USERLOGGEDIN"))
                    self.redirectToChallengeViewStoryboard()
                }
            }
        }
//        UserService.instance.incrementUserScore(points: 10, userId: "ZDzTjDooIfVRvtDWpLnkDcsU7wj1")
    }
    
    // Redirect to register view
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        self.showOnCurrentStoryboard(identifier: "registerIdentifier")
    }
    
    // Redirect to login view
    @IBAction func backLoginButtonTapped(_ sender: UIButton) {
        self.showOnCurrentStoryboard(identifier: "loginIdentifier")
    }
    
    // Create a new User and fill in his challenge list
    private func initUser(email: String, name: String, password: String, repeatPassword: String) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                self.showAlert(title: "Error", message: "An error occured during sign in.")
            } else if let user = user {
                let db = Firestore.firestore()
                ChallengeService.instance.getAllChallenges(level: 1, callback: { (challenges) in
                    var challengeIds = [String]()
                    for challenge in challenges {
                        challengeIds.append(challenge.uid)
                        db.collection("challenge_run").addDocument(data: [
                            "name": challenge.name,
                            "level": challenge.level,
                            "description": challenge.description,
                            "points": challenge.points,
                            "short_description": challenge.short_description,
                            "repetition": challenge.repetition,
                            "repetition_completed": 0,
                            "repetition_type": challenge.repetition_type,
                            "repetition_name": challenge.repetition_name,
                            "type": challenge.type,
                            "user_id": user.user.uid,
                            "completed": false,
                            "challenge_id": challenge.uid,
                        ])
                    }
                    db.collection("user_detail").document(user.user.uid).setData(["name": name, "score": 0, "level": 1, "challenges_ids": challengeIds, "user_id": user.user.uid])
                })
                self.redirectToChallengeViewStoryboard()
            }
        })
    }
    
    // Display an alert
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true);
    }
    
    // Present view on current Storyboard by identifier
    private func showOnCurrentStoryboard(identifier: String){
        if let authViewcontroller = self.storyboard?.instantiateViewController(withIdentifier: identifier) as? AuthViewController {
            self.present(authViewcontroller, animated: false, completion: nil)
        }
    }
    
    private func redirectToChallengeViewStoryboard() {
        var homeStoryboard: UIStoryboard!
        homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        
        if let challengesViewcontroller = homeStoryboard.instantiateViewController(withIdentifier: "homeTapBarControllerIdentifier") as? UITabBarController {
            self.present(challengesViewcontroller, animated: true, completion: nil)
        }

    }
}

