//
//  ProfilViewController.swift
//  EcoCap
//
//  Created by Renan Bronchart on 04/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit
import FirebaseAuth

struct Section {
    var type: String
    var belonging: [ChallengeRun]
}

class ProfilViewController: UIViewController {
    @IBOutlet weak var profilImageView: UIImageView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var challengeCompletedLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var levelNameLabel: UILabel!
    @IBOutlet weak var remainingPointsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var levelUserLabel: UILabel!
    @IBOutlet weak var userProgressView: ProgressBarView!
    
    @IBAction func goToSettings(_ sender: Any) {
        if let settingsViewController = self.storyboard?.instantiateViewController(withIdentifier: "settingsViewControllerIdentifier") as? SettingsViewController {
            self.present(settingsViewController, animated: true, completion: nil)
        }
    }
    
    lazy var themas = [Thema]()
    var sections = [Section]()
    var user: UserDetail!
    var challenges_user = [ChallengeRun]()
    var challenges_weekly = [ChallengeRun]()
    var challenges_daily = [ChallengeRun]()
    var challenges_monthly = [ChallengeRun]()
    
    override func viewDidAppear(_ animated: Bool) {
        if let userId = Auth.auth().currentUser?.uid {
            ChallengeService.instance.getAllChallengeRuns(userId: userId, completed: true) { (challenges_run) in
                self.sections = []
                self.challenges_user = challenges_run
                self.challenges_daily = challenges_run.filter({$0.repetition_type == "daily"})
                self.challenges_monthly = challenges_run.filter({$0.repetition_type == "monthly"})
                self.challenges_weekly = challenges_run.filter({$0.repetition_type == "weekly"})
                
                self.challengeCompletedLabel.text = "\(self.challenges_user.count)"
                
                let today = Section(type: "Journaliers", belonging: self.challenges_daily)
                let week = Section(type: "Hebdomadaires", belonging: self.challenges_monthly)
                let month = Section(type: "Mensuels", belonging: self.challenges_weekly)
                
                self.sections.append(today)
                self.sections.append(week)
                self.sections.append(month)
                
                self.tableView.reloadData()
            }
        }
        
        UserService.instance.getUserDetail(callback: { (userDetail) in
            self.user = userDetail
            self.profilImageView.image = UIImage(named: "avatar_level_\(self.user.level)")
            self.levelUserLabel.text = "N.\(self.user.level)"
            
            self.pointsLabel.text = "\(userDetail.score)"
            self.userNameLabel.text = userDetail.name
            
            LevelService.instance.getAllLevels { (levels) in
                self.setDataInHeader(levels: levels, user: userDetail)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ThemaService.instance.getAllThemas(callback: { (themas) in
            self.tableView.reloadData()
            self.themas = themas
        })
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setDataInHeader (levels: [Level], user: UserDetail) {
        let currentLevel = levels[user.level - 1]
        let requiredLeftLevel = levels.indices.contains(user.level - 2) ? levels[user.level - 2].required : 0
        let totalLevelPoint = currentLevel.required - requiredLeftLevel
        let remainingPoints = totalLevelPoint - (user.score - requiredLeftLevel)
        let progressInLevel = currentLevel.required - remainingPoints
        let minValue = progressInLevel
        let maxValue = currentLevel.required
        
        userProgressView.progress = Float(minValue) / Float(maxValue)
        remainingPointsLabel.text = "\(remainingPoints) pts"
        self.levelNameLabel.text = "\(currentLevel.pseudo_name)"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ProfilViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].belonging.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileTableViewCellIdentifier") as! ProfileTableViewCell
        let row = indexPath.row
        
        let challenge = sections[indexPath.section].belonging[row]
        if let found = themas.first(where: { $0.name == challenge.type }) {
            cell.thema = found
        }

        cell.challenge = challenge
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        
        label.text = sections[section].type
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.frame = CGRect(x: 16, y: 0, width: self.view.frame.width - 32, height: 35)
        label.textColor = UIColor(red: 84 / 255, green: 84 / 255, blue: 84 / 255, alpha: 1)
        
        view.addSubview(label)
        view.backgroundColor = UIColor.white
        
        return view
    }
}
