//
//  ChallengesTableViewCell.swift
//  EcoCap
//
//  Created by Renan Bronchart on 27/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

protocol CellProgressDelegate {
    func didCompleteChallenge(_ challenge: ChallengeRun)
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
    
    var challenge: ChallengeRun! {
        didSet {
            challenge.repetition_completed = challenge.repetition_completed ?? 0
            
            // mettre à jour le challenge user
            
            challengeNameLabel.text = challenge.name
            challengeProgressLabel.text = "\(challenge.repetition - challenge.repetition_completed!)"
            challengePercentLabel.text = "\("\(challenge.repetition_completed! * 100 / challenge.repetition)")"
            challengeValue = challenge.points
            maxValue = challenge.repetition * 10
            minValue = challenge.repetition_completed! * 10
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
                challenge.repetition_completed = minValue / 10
                challengeProgressLabel.text = "\((maxValue / 10) - (minValue / 10))"
                challengeProgressBar.progress = Float(minValue) / Float(maxValue)
            } else {
                downloader.invalidate()
                challengeButton.isEnabled = true
                
                delegate?.didChangeChallengeCompleteMissions(value: challenge.repetition_completed! * 10)
            }
        } else {
            minValue = 0
            more = minValue
            delegate?.didCompleteChallenge(challenge)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        customViewCell.firstColor = UIColor(hexString: "#E94366")
        customViewCell.secondColor = UIColor(hexString: "#F3AC5A")

        
        challengeProgressBar.setProgress((Float(minValue) / Float(maxValue)), animated: false)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension ChallengesTableViewCell: ChallengeDetailDelegate {
    func didCompleteChallengeDetail(_ challenge: ChallengeRun) {
        delegate?.didCompleteChallenge(challenge)
    }
    
    func didChangeChallengeCompleteMissions(value: Int) {
        challenge.repetition_completed = value
        minValue = value * 10
        challengeProgressLabel.text = "\((maxValue / 10) - (minValue / 10))"
        challengeProgressBar.progress = Float(minValue) / Float(maxValue)
        
        delegate?.didChangeChallengeCompleteMissions(value: value)
    }
}
