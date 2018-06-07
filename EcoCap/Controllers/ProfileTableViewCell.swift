//
//  ProfileTableViewCell.swift
//  EcoCap
//
//  Created by Renan Bronchart on 05/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var challengeTypeImageView: UIImageView!
    @IBOutlet weak var challengeNameLabel: UILabel!
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var customViewCellGradient: CustomViewCell!
    
    var thema: Thema! {
        didSet {
            let firstColor = thema.color_gradient_1
            let secondColor = thema.color_gradient_2
            
            customViewCellGradient.firstColor = UIColor(hexString: firstColor)
            customViewCellGradient.secondColor = UIColor(hexString: secondColor)
        }
    }
    
    var challenge: ChallengeRun! {
        didSet {
            challengeNameLabel.text = challenge.name
            shortDescriptionLabel.text = challenge.short_description
            
            challengeTypeImageView.image = UIImage(named: "icn_\(challenge.type)")
            checkImageView.image = UIImage(named: "check_\(challenge.type)")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
