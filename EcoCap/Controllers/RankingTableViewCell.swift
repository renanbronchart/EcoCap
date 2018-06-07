//
//  RankingTableViewCell.swift
//  EcoCap
//
//  Created by Renan Bronchart on 05/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class RankingTableViewCell: UITableViewCell {
//    var currentUser: UserDetail!
//    var user: UserDetail!
    
    @IBOutlet weak var customViewCell: CustomViewCell!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userCompletionLabel: UILabel!
    @IBOutlet weak var userTotalPoints: UILabel!
    @IBOutlet weak var userRankingLabel: UILabel!
    @IBOutlet weak var containerLevelImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerLevelImage.image = UIImage(named: "rank_other")
        
//        customViewCell.firstColor...
//
//        if (currentUser.user_id == user.user_id) {
//            customViewCell.firstColor = UIColor(hexString: "#fffff")
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
