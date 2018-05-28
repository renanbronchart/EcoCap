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

    @IBOutlet weak var customViewCell: CustomViewCell!
    
    
//    @IBAction func buttonMission(_ sender: Any) {
//        print("mission + 1")
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        customViewCell.firstColor = UIColor(displayP3Red: 255/255, green: 42/255, blue: 101/255, alpha: 1)
        customViewCell.secondColor = UIColor(displayP3Red: 254/255, green: 169/255, blue: 70/255, alpha: 1)


        
//        titleChallengeLabel.text = challenge
//        gradientView.layer.cornerRadius = 30
//        gradientView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
