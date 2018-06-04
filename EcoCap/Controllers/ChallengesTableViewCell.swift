//
//  ChallengesTableViewCell.swift
//  EcoCap
//
//  Created by Renan Bronchart on 27/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

protocol CellProgressDelegate {
    func didCompleteChallenge(value: Int)
    func didChangeChallengeCompleteMissions(value: Int)
}

class ChallengesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var customViewCell: CustomViewCell!
    @IBOutlet weak var challengeNameLabel: UILabel!
    
    @IBOutlet weak var challengeShortDescriptionLabel: UILabel!
    @IBOutlet weak var challengeButton: UIButton!
    
    @IBOutlet weak var challengeProgressBar: ProgressBarView!
    @IBOutlet weak var challengeProgressLabel: UILabel!
    @IBOutlet weak var challengePercentLabel: UILabel!
    
    var delegate: CellProgressDelegate?
    
    var minValue = 0
    var maxValue = 100
    var xpMore = 10
    var more: Int = 0
    var downloader = Timer()
    var challengeValue: Int = 0
    
    var challenge: Challenge! {
        didSet {
            challengeNameLabel.text = challenge.name
            challengeProgressLabel.text = "\(challenge.total_missions - challenge.complete_missions)"
            challengePercentLabel.text = "\("\(challenge.complete_missions * 100 / challenge.total_missions)")"
            challengeValue = challenge.value
            maxValue = challenge.total_missions * 10
            minValue = challenge.complete_missions * 10
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
                challenge.complete_missions = minValue / 10
                challengeProgressLabel.text = "\((maxValue / 10) - (minValue / 10))"
                challengeProgressBar.progress = Float(minValue) / Float(maxValue)
            } else {
                downloader.invalidate()
                challengeButton.isEnabled = true
                
                delegate?.didChangeChallengeCompleteMissions(value: challenge.complete_missions * 10)
            }
        } else {
            minValue = 0
            more = minValue
            delegate?.didCompleteChallenge(value: challengeValue)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        customViewCell.firstColor = UIColor(hexString: "#E94366")
        customViewCell.secondColor = UIColor(hexString: "#F3AC5A")

        
        challengeProgressBar.setProgress((Float(minValue) / Float(maxValue)), animated: false)
        
//        titleChallengeLabel.text = challenge
//        gradientView.layer.cornerRadius = 30
//        gradientView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension ChallengesTableViewCell: ChallengeDetailDelegate {
    func didCompleteChallengeDetail(value: Int) {
        delegate?.didCompleteChallenge(value: value)
    }
    
    func didChangeChallengeCompleteMissions(value: Int) {
        challenge.complete_missions = value
        minValue = value * 10
        challengeProgressLabel.text = "\((maxValue / 10) - (minValue / 10))"
        challengeProgressBar.progress = Float(minValue) / Float(maxValue)
        
        delegate?.didChangeChallengeCompleteMissions(value: value)
    }
}
