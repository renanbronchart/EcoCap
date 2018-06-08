//
//  SettingsViewController.swift
//  EcoCap
//
//  Created by Renan Bronchart on 26/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey:"USERLOGGEDIN")
        
        var AuthStoryboard: UIStoryboard!
        
        AuthStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        
        if let authViewController = AuthStoryboard.instantiateViewController(withIdentifier: "loginIdentifier") as? AuthViewController {
            self.present(authViewController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
