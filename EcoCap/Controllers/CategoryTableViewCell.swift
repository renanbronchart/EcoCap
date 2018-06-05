//
//  CategoryTableViewCell.swift
//  EcoCap
//
//  Created by Renan Bronchart on 28/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

protocol FilterChallengeDelegate {
    func didCompleteChallenge(value: Int)
    func didChangeChallengeCompleteMissions(value: Int)
}

class CategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var dailyButton: GradientRoundedButton!
    @IBOutlet weak var weeklyButton: GradientRoundedButton!
    @IBOutlet weak var monthlyButton: GradientRoundedButton!
    
    @IBAction func filterByMonth(_ sender: Any) {
        dailyButton.isSelected = false
        weeklyButton.isSelected = false
        monthlyButton.isSelected = true
        
        // call service challenge filter by challenge month
    }
    
    @IBAction func filterByWeek(_ sender: Any) {
        dailyButton.isSelected = false
        weeklyButton.isSelected = true
        monthlyButton.isSelected = false
        
        // call service challenge filter by challenge week
    }
    
    @IBAction func filterByDay(_ sender: Any) {
        dailyButton.isSelected = true
        weeklyButton.isSelected = false
        monthlyButton.isSelected = false
        
        // call service challenge filter by challenge day
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
