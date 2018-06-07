//
//  DetailChallengeViewController.swift
//  EcoCap
//
//  Created by Renan Bronchart on 29/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

protocol ChallengeDetailDelegate {
    func didCompleteChallengeDetail(_ challenge: ChallengeRun)
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
    @IBOutlet weak var footerInformationLabel: UILabel!
    @IBOutlet weak var bodyInformationLabel: UILabel!
    
    @IBOutlet weak var thematicImage: UIImageView!
    @IBOutlet weak var informationScrollView: UIScrollView!
    
    var challenge: ChallengeRun!
    var thema: Thema!
    var delegate: ChallengeDetailDelegate?
    
    var minValue = 0
    var maxValue = 200
    var xpMore = 10
    var more: Int = 0
    var downloader = Timer()
    var challengeValue: Int = 0

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.clipsToBounds = true

        thematicImage.image = UIImage(named: "icn_\(thema.name!)")
        categoryLabel.text = "\(thema.description!)"
        challengeDetailButton.setImage(UIImage(named: "btn_plus_\(thema.name!)"), for: .normal)
        
        let firstColor = thema?.color_gradient_1 ?? "#E94366"
        let secondColor = thema?.color_gradient_2 ?? "#F3AC5A"
        
        gradientView.firstColor = UIColor(hexString: firstColor)
        gradientView.secondColor = UIColor(hexString: secondColor)
        
        titleInformationLabel.textColor = UIColor(hexString: firstColor)
        footerInformationLabel.textColor = UIColor(hexString: firstColor)

        bodyInformationLabel.text = challenge.description
        
        challengeNameLabel.text = challenge?.name
        pointsLabel.text = "\(challenge.points!) pts"
        challengeValue = challenge.points
        
        percentLabel.text = "\((challenge.repetition_completed! * 100) / challenge.repetition)"

        maxValue = challenge.repetition * 10
        minValue = challenge.repetition_completed! * 10
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
                challenge.repetition_completed! += 1
                percentLabel.text = "\((challenge.repetition_completed! * 100) / challenge.repetition)"
                delegate?.didChangeChallengeCompleteMissions(value: (minValue / 10))
                downloader.invalidate()
                challengeDetailButton.isEnabled = true
            }
        } else {
            minValue = 0
            more = minValue
            delegate?.didCompleteChallengeDetail(challenge)
            
            self.navigationController?.popViewController(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
