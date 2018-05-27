//
//  ChallengesTableViewCell.swift
//  EcoCap
//
//  Created by Renan Bronchart on 27/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class ChallengesTableViewCell: UITableViewCell {
    
    var challenge = ""

    @IBOutlet weak var titleChallengeLabel: UILabel!
    @IBOutlet weak var descriptionChallengeLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var moreThanLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var remaingCompleteChallengeLabel: UILabel!
    @IBOutlet weak var progressCompleteChallenge: UIProgressView!
    
    @IBAction func buttonMission(_ sender: Any) {
        print("mission + 1")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        titleChallengeLabel.text = challenge
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
