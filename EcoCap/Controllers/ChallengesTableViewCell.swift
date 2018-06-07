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

    @IBOutlet weak var challengeTypeImage: UIImageView!
    var delegate: CellProgressDelegate?
    var thema: Thema?
    var minValue = 0
    var maxValue = 100
    var xpMore = 10
    var more: Int = 0
    var downloader = Timer()
    var challengeValue: Int = 0

    var challenge: ChallengeRun! {
        didSet {
            challenge.repetition_completed = challenge.repetition_completed

            challengeNameLabel.text = challenge.name
            challengeShortDescriptionLabel.text = challenge.short_description
            challengeProgressLabel.text = "\(challenge.repetition - challenge.repetition_completed) \(challenge.repetition_name)"
            challengePercentLabel.text = "\("\(challenge.repetition_completed * 100 / challenge.repetition)") %"
            challengeValue = challenge.points
            maxValue = challenge.repetition * 10
            minValue = challenge.repetition_completed * 10
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
                challengeProgressLabel.text = "\((maxValue / 10) - (minValue / 10)) \(challenge.repetition_name)"
                challengeProgressBar.progress = Float(minValue) / Float(maxValue)
            } else {
                downloader.invalidate()
                challengeButton.isEnabled = true
                challengePercentLabel.text = "\("\(challenge.repetition_completed * 100 / challenge.repetition)") %"

                delegate?.didChangeChallengeCompleteMissions(value: challenge.repetition_completed * 10)
            }
        } else {
            minValue = 0
            more = minValue
            delegate?.didCompleteChallenge(challenge)
        }
    }

    override func draw(_ rect: CGRect) {
        let firstColor = thema?.color_gradient_1 ?? "#E94366"
        let secondColor = thema?.color_gradient_2 ?? "#F3AC5A"

        customViewCell.firstColor = UIColor(hexString: firstColor)
        customViewCell.secondColor = UIColor(hexString: secondColor)

        challengeProgressBar.firstColor = UIColor(hexString: firstColor)
        challengeProgressBar.secondColor = UIColor(hexString: secondColor)
        challengeTypeImage.image = UIImage(named: "icn_\(challenge.type)")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.none

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

    func didChangeChallengeCompleteMissions(challenge: ChallengeRun) {
        self.challenge = challenge
//        minValue = challenge.repetition_completed ?? 0
//        challengeProgressLabel.text = "\((maxValue / 10) - (minValue / 10)) \(challenge.repetition_name!)"
        challengeProgressBar.progress = Float(minValue) / Float(maxValue)

        delegate?.didChangeChallengeCompleteMissions(value: challenge.points)
    }
}
