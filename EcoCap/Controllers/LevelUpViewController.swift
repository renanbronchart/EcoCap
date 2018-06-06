//
//  LevelUpViewController.swift
//  EcoCap
//
//  Created by Renan Bronchart on 06/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class LevelUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func moveNextLevel(_ sender: Any) {
        var homeStoryboard: UIStoryboard!
        homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        
        if let challengesViewcontroller = homeStoryboard.instantiateViewController(withIdentifier: "challengesViewControllerIdentifier") as? ChallengesViewController {
            self.present(challengesViewcontroller, animated: true, completion: nil)
        }
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
