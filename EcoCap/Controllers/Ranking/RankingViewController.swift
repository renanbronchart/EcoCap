//
//  RankingViewController.swift
//  EcoCap
//
//  Created by Renan Bronchart on 26/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit
import FirebaseAuth

class RankingViewController: UIViewController {
    
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

    @IBOutlet weak var firstUserImage: UIImageView!
    @IBOutlet weak var firstUserNameLabel: UILabel!
    @IBOutlet weak var firstUserCompletionLabel: UILabel!
    
    @IBOutlet weak var secondUserImage: UIImageView!
    @IBOutlet weak var secondUserNameLabel: UILabel!
    @IBOutlet weak var secondUserCompletionLabel: UILabel!
    
    @IBOutlet weak var thirdUserImage: UIImageView!
    @IBOutlet weak var thirdUserNameLabel: UILabel!
    @IBOutlet weak var thirdUserCompletionLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var users: [UserDetail]! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserService.instance.getUserDetailsOrderedByScore { (userDetails) in
            
            var yolo = userDetails
            ChallengeService.instance.getAllChallengeRuns(userId: yolo[0].user_id, completed: true, callback: { (challengeRuns) in
                self.firstUserCompletionLabel.text = "\(challengeRuns.count) défis"
            })
            ChallengeService.instance.getAllChallengeRuns(userId: yolo[1].user_id, completed: true, callback: { (challengeRuns) in
                self.secondUserCompletionLabel.text = "\(challengeRuns.count) défis"
            })
            ChallengeService.instance.getAllChallengeRuns(userId: yolo[2].user_id, completed: true, callback: { (challengeRuns) in
                self.thirdUserCompletionLabel.text = "\(challengeRuns.count) défis"
            })
            self.firstUserNameLabel.text = yolo[0].name
            self.secondUserNameLabel.text = yolo[1].name
            self.thirdUserNameLabel.text = yolo[2].name
            yolo.removeFirst(3)
            self.users = yolo
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension RankingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rankingTableViewCellIdentifier") as! RankingTableViewCell
        cell.user = self.users[indexPath.row]
        ChallengeService.instance.getAllChallengeRuns(userId: self.users[indexPath.row].user_id, completed: true, callback: { (challengeRuns) in
            cell.challengeRunsCompleted = challengeRuns.count
        })
        cell.rank = indexPath.row + 4
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 99
    }
}
