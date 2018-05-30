//
//  DetailChallengeViewController.swift
//  EcoCap
//
//  Created by Renan Bronchart on 29/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class DetailChallengeViewController: UIViewController {
    
    @IBOutlet weak var challengeNameLabel: UILabel!
    
    var challenge: ChallengeBeta!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        challengeNameLabel.text = challenge?.name

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
