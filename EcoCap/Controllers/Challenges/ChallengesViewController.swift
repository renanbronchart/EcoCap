//
//  ChallengesViewController.swift
//  EcoCap
//
//  Created by Renan Bronchart on 26/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol ChallengesHomeDelegate {
    func didCompleteLevel(_ level: Level)
}

class ChallengesViewController: UIViewController {
    lazy var levels = [Level]()
    var user: UserDetail!
    lazy var challenges_user = [ChallengeRun]()
    lazy var allChallengesUser = [ChallengeRun]()
    lazy var themas = [Thema]()
    
    var delegate: ChallengesHomeDelegate?
    var minValue = 0
    var maxValue = 100
    var xpMore = 0
    var more: Int = 0
    var downloader = Timer()
    var currentLevel: Level!
    var userPoints: Int = 0
    var remainingPoints: Int = 0

    @IBOutlet weak var headerStickyHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerStickyView: HeaderStickyView!
    @IBOutlet weak var remainingPointsLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var titleHeaderStickyLabel: UILabel!
    @IBOutlet weak var headerProgressView: ProgressBarView!
    @IBOutlet weak var gradientView: GradientView!

    @IBOutlet weak var progressViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func startDownload() {
        more = minValue + xpMore
        downloader = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: (#selector(self.updater)), userInfo: nil, repeats: true)
    }

    @objc func updater () {
        if minValue != maxValue {
            if minValue != more {
                minValue += 1
                headerProgressView.progress = Float(minValue) / Float(maxValue)
            } else {
                downloader.invalidate()
                self.user.score = self.userPoints
                
                // Set user with new user details
                UserService.instance.updateUserDetail(userDetail: self.user) { (currentUserDetail, userDetail, levelUp) in
                    UserService.instance.updateUserDetailAction(userDetailId: currentUserDetail, userDetail: userDetail, hasLevelUp: levelUp)
                }
            }
        } else {
            minValue = 0
            more = minValue
            
            self.currentLevel = levels[self.user.level]
            self.user.score = self.userPoints
            self.user.level = self.currentLevel.number
            
            levelLabel.text = String("\(self.currentLevel.name)")
            
            UserService.instance.updateUserDetail(userDetail: self.user) { (currentUserDetail, userDetail, levelUp) in
                UserService.instance.updateUserDetailAction(userDetailId: currentUserDetail, userDetail: userDetail, hasLevelUp: levelUp)
            }
            
            delegate?.didCompleteLevel(self.currentLevel)
            
            if let levelUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "levelUpViewControllerIdentifier") as? LevelUpViewController {
                levelUpViewController.level = self.currentLevel
                self.present(levelUpViewController, animated: true, completion: nil)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Récupérer les thémas avec le service des thématique
        ThemaService.instance.getAllThemas(callback: { (themas) in
            self.themas += themas
            
            self.tableView.reloadData()
        })

        if let userId = Auth.auth().currentUser?.uid {
            ChallengeService.instance.getAllChallengeRuns(userId: userId, completed: false) { (challenges_run) in
                self.allChallengesUser = challenges_run
                self.challenges_user = self.allChallengesUser.filter({$0.repetition_type == "daily"})
                self.tableView.reloadData()
            }
        }

        UserService.instance.getUserDetail(callback: { (userDetail) in
            self.user = userDetail
            self.userPoints = self.user.score
            
            LevelService.instance.getAllLevels { (levels) in
                self.levels = levels
                self.setDataInHeader()
            }
        })
    
        // Add delegate to self to use native function table View
        tableView.delegate = self
        tableView.dataSource = self
        headerProgressView.setProgress(0, animated: false)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setDataInHeader () {
        self.currentLevel = levels[self.user.level - 1]
        let requiredLeftLevel = levels.indices.contains(self.user.level - 2) ? levels[self.user.level - 2].required : 0
        let totalLevelPoint = currentLevel.required - requiredLeftLevel
        
        remainingPoints = totalLevelPoint - (userPoints - requiredLeftLevel)

        let progressInLevel = currentLevel.required - remainingPoints
        self.minValue = progressInLevel
        self.maxValue = currentLevel.required

        headerProgressView.progress = Float(minValue) / Float(maxValue)

        levelLabel.text = String("\(currentLevel.name)")
        remainingPointsLabel.text = "Encore \(remainingPoints) points"
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.isNavigationBarHidden = false
    }
}

extension ChallengesViewController: CellProgressDelegate {
    func didChangeChallengeCompleteMissions(_ challenge: ChallengeRun) {
        ChallengeService.instance.updateChallengeRun(challengeRun : challenge) { (challengeRunId, challengeRun) in
            ChallengeService.instance.updateChallengeRunAction(challengeRunId: challengeRunId, challengeRun: challengeRun)
        }
        
        if let index = allChallengesUser.index(where: { $0.challenge_id == challenge.challenge_id }) {
            allChallengesUser[index] = challenge
        }
        
        if let index = challenges_user.index(where: { $0.challenge_id == challenge.challenge_id }) {
            challenges_user[index] = challenge
        }
    }

    func didCompleteChallenge(_ challenge: ChallengeRun) {
        self.xpMore = challenge.points
        self.remainingPoints -= challenge.points
        self.remainingPointsLabel.text = "Encore \(self.remainingPoints) points"
        
        ChallengeService.instance.updateChallengeRun(challengeRun : challenge) { (challengeRunId, challengeRun) in
            ChallengeService.instance.updateChallengeRunAction(challengeRunId: challengeRunId, challengeRun: challengeRun)
        }
        
        if let index = allChallengesUser.index(where: { $0.challenge_id == challenge.challenge_id }) {
            allChallengesUser[index] = challenge
        }
        
        if let index = challenges_user.index(where: { $0.challenge_id == challenge.challenge_id }) {
            allChallengesUser[index] = challenge
            challenges_user.remove(at: index)
            let indexPath = IndexPath(item: index + 1, section: 0)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
        
        self.userPoints += challenge.points
        self.user.score = self.userPoints

        self.startDownload()
    }
}

extension ChallengesViewController: FilterChallengeDelegate {
    func didFilterBy(type: String) {
        self.challenges_user = allChallengesUser.filter({
            $0.repetition_type == type && $0.completed == false
        })
        
        tableView.reloadData()
    }
}

extension ChallengesViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges_user.count + 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 76
        } else {
            return UITableViewAutomaticDimension
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 76
        } else {
            return 192
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTableViewCellIdentifier") as! CategoryTableViewCell

            cell.delegate = self

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "challengesTableViewCellIdentifier") as! ChallengesTableViewCell
            let challenge = challenges_user[row - 1]

            if let found = themas.first(where: { $0.name == challenge.type }) {
                cell.thema = found
            }

            cell.challenge = challenge
            cell.delegate = self

            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            if let detailChallengeView =
                self.storyboard?.instantiateViewController(withIdentifier: "detailChallengeViewControllerIdentifier") as? DetailChallengeViewController {
                let currentCell = tableView.cellForRow(at: indexPath)
                let challenge = challenges_user[indexPath.row - 1]
                
                detailChallengeView.delegate = currentCell as? ChallengeDetailDelegate
                detailChallengeView.challenge = challenge

                if let found = themas.first(where: { $0.name == challenge.type }) {
                    detailChallengeView.thema = found
                }

                self.navigationController?.pushViewController(detailChallengeView, animated: true)
            }
        }
    }
}

extension ChallengesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y < 0) {
            if (self.headerStickyHeightConstraint.constant > 110) {
                animateHeader()
            } else {
                self.headerStickyHeightConstraint.constant += abs(scrollView.contentOffset.y)

                self.progressViewTopConstraint.constant += abs(scrollView.contentOffset.y)

                headerStickyView.decrementLabelAlpha(label: titleHeaderStickyLabel, offset: headerStickyHeightConstraint.constant)
            }

        } else if (scrollView.contentOffset.y > 0) {
            if (self.headerStickyHeightConstraint.constant >= 80) {
                self.headerStickyHeightConstraint.constant -= scrollView.contentOffset.y / 104
            }

            if (self.progressViewTopConstraint.constant >= 16) {
                self.progressViewTopConstraint.constant -= scrollView.contentOffset.y / 104
            }

            headerStickyView.incrementLabelAlpha(label: titleHeaderStickyLabel, offset: headerStickyHeightConstraint.constant)
        }

        if self.headerStickyHeightConstraint.constant < 80 {
            self.headerStickyHeightConstraint.constant = 80
        }

        if self.progressViewTopConstraint.constant < 16 {
            self.progressViewTopConstraint.constant = 16
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.headerStickyHeightConstraint.constant > 110 {
            animateHeader()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.headerStickyHeightConstraint.constant > 110 {
            animateHeader()
        }
    }

    func animateHeader () {
        headerStickyHeightConstraint.constant = 110
        progressViewTopConstraint.constant = 24
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

