//
//  LevelUpViewController.swift
//  EcoCap
//
//  Created by Renan Bronchart on 06/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class LevelUpViewController: UIViewController {
    var level: Level!
    
    @IBOutlet weak var levelLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        levelLabel.text = level.name
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func moveNextLevel(_ sender: Any) {
        if let challengesViewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "homeTapBarControllerIdentifier") as? UITabBarController {
            self.present(challengesViewcontroller, animated: true, completion: nil)
        }
    }
}

extension LevelUpViewController: ChallengesHomeDelegate {
    func didCompleteLevel(_ level: Level) {
        
    }
}
