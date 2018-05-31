//
//  DetailChallengeViewController.swift
//  EcoCap
//
//  Created by Renan Bronchart on 29/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class DetailChallengeViewController: UIViewController {
    
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var challengeNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var titleInformationLabel: UILabel!
    @IBOutlet weak var informationChallengeView: UIView!
    
    var challenge: ChallengeBeta!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        
        challengeNameLabel.text = challenge?.name
        pointsLabel.text = "\(challenge.value!) pts"
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
