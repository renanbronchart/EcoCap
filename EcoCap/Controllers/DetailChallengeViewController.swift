//
//  DetailChallengeViewController.swift
//  EcoCap
//
//  Created by Renan Bronchart on 29/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

protocol ChallengeDetailDelegate {
    func didCompleteChallengeDetail(value: Int)
    func didChangeChallengeCompleteMissions(value: Int)
}

class DetailChallengeViewController: UIViewController {
    
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var challengeNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    @IBOutlet weak var challengeProgressBar: ProgressBarView!
    
    @IBOutlet weak var challengeDetailButton: GradientRoundedButton!
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var titleInformationLabel: UILabel!
    @IBOutlet weak var informationChallengeView: UIView!
    
    @IBOutlet weak var informationScrollView: UIScrollView!
    
    var challenge: Challenge!
    var delegate: ChallengeDetailDelegate?
    
    var minValue = 0
    var maxValue = 200
    var xpMore = 10
    var more: Int = 0
    var downloader = Timer()
    var challengeValue: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        informationScrollView.delegate = self
        
        self.view.clipsToBounds = true
        
        challengeNameLabel.text = challenge?.name
        pointsLabel.text = "\(challenge.value!) pts"
        challengeValue = challenge.value
        
        maxValue = challenge.total_missions * 10
        minValue = challenge.complete_missions * 10
        challengeProgressBar.setProgress((Float(minValue) / Float(maxValue)), animated: false)
        progressLabel.text = "\((maxValue / 10) - (minValue / 10))"
    }
    
    @IBAction func completeChallenge(_ sender: Any) {
        challengeDetailButton.isEnabled = false
        more = minValue + xpMore
        downloader = Timer.scheduledTimer(timeInterval: 0.06, target: self, selector: (#selector(self.updater)), userInfo: nil, repeats: true)
    }
    
    @objc func updater () {
        if minValue != maxValue {
            if minValue != more {
                minValue += 1
                progressLabel.text = "\((maxValue / 10) - (minValue / 10))"
                challengeProgressBar.progress = Float(minValue) / Float(maxValue)
            } else {
                print("before delegate")
                delegate?.didChangeChallengeCompleteMissions(value: (minValue / 10))
                downloader.invalidate()
                challengeDetailButton.isEnabled = true
            }
        } else {
            minValue = 0
            more = minValue
            delegate?.didCompleteChallengeDetail(value: challengeValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DetailChallengeViewController: UIScrollViewDelegate {
    
}
