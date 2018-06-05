//
//  ProfileTableViewCell.swift
//  EcoCap
//
//  Created by Renan Bronchart on 05/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var customViewCellGradient: CustomViewCell!
    @IBOutlet weak var logoCategoryImageView: UIImageView!
    @IBOutlet weak var challengeNameLabel: UILabel!
    @IBOutlet weak var challengeShortDescriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        customViewCellGradient.firstColor = UIColor(hexString: "#E94366")
        customViewCellGradient.secondColor = UIColor(hexString: "#F3AC5A")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
