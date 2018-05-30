//
//  ChallengesTableViewCell.swift
//  EcoCap
//
//  Created by Renan Bronchart on 27/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class ChallengesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var customViewCell: CustomViewCell!
    @IBOutlet weak var challengeNameLabel: UILabel!
    
    @IBOutlet weak var challengeShortDescriptionLabel: UILabel!
    @IBOutlet weak var challengeButton: UIButton!
    
    @IBOutlet weak var challengeProgressBar: ProgressBarView!
    @IBOutlet weak var challengeProgressLabel: UILabel!
    @IBOutlet weak var challengePercentLabel: UILabel!
    
    var minValue = 0
    var maxValue = 100
    var xpMore = 10
    var more: Int = 0
    var downloader = Timer()
    
    var challenge: ChallengeBeta! {
        didSet {
            challengeNameLabel.text = challenge.name
            challengeProgressLabel.text = "\(challenge.total_missions - challenge.complete_missions)"
            challengePercentLabel.text = "\("\(challenge.complete_missions * 100 / challenge.total_missions)")"
        }
    }
    
    @IBAction func startDownload(_ sender: Any) {
        challengeButton.isEnabled = false
        more = minValue + xpMore
        downloader = Timer.scheduledTimer(timeInterval: 0.06, target: self, selector: (#selector(self.updater)), userInfo: nil, repeats: true)
    }
    
    @objc func updater () {
        if minValue != maxValue {
            if minValue != more {
                minValue += 1
                challengeProgressLabel.text = "\(minValue)"
                challengeProgressBar.progress = Float(minValue) / Float(maxValue)
            } else {
                downloader.invalidate()
                challengeButton.isEnabled = true
            }
        } else {
            minValue = 0
            more = minValue
            print("Niveau suivant")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        customViewCell.firstColor = UIColor(displayP3Red: 255/255, green: 42/255, blue: 101/255, alpha: 1)
        customViewCell.secondColor = UIColor(displayP3Red: 254/255, green: 169/255, blue: 70/255, alpha: 1)

        
        challengeProgressBar.setProgress(0, animated: false)
        
//        titleChallengeLabel.text = challenge
//        gradientView.layer.cornerRadius = 30
//        gradientView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
