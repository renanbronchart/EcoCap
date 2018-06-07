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

class ChallengesViewController: UIViewController {

    lazy var challenges = [ChallengeRun]()
    lazy var levels = [Level]()
    var user: UserDetail!
    lazy var challenges_user = [ChallengeRun]()
    lazy var allChallengesUser = [ChallengeRun]()
    lazy var themas = [Thema]()

    var minValue = 0
    var maxValue = 100
    var xpMore = 0
    var more: Int = 0
    var downloader = Timer()
    var currentLevel: Level!
    var userPoints: Int = 0
    var remainingPoints: Int = 5000

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
        downloader = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: (#selector(self.updater)), userInfo: nil, repeats: true)
    }

    @objc func updater () {
        if minValue != maxValue {
            if minValue != more {
                minValue += 5
                headerProgressView.progress = Float(minValue) / Float(maxValue)
            } else {
                downloader.invalidate()
            }
        } else {
            minValue = 0
            more = minValue
            if let levelUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "levelUpViewControllerIdentifier") as? LevelUpViewController {
                self.present(levelUpViewController, animated: true, completion: nil)
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Récupérer les thémas avec le service des thématique
        themas.append(Thema(color_gradient_1: "#5245C5", color_gradient_2: "#61A8FB", description: "Agir en société", name: "society"))
        themas.append(Thema(color_gradient_1: "#58E4F5", color_gradient_2: "#2DBEDA", description: "Préservez l'eau", name: "water"))
        themas.append(Thema(color_gradient_1: "#614FE8", color_gradient_2: "#FFCAE6", description: "Acheter responsable", name: "buy"))
        themas.append(Thema(color_gradient_1: "#983BB6", color_gradient_2: "#FEA6D1", description: "Réduire mes déchets", name: "draft"))
        themas.append(Thema(color_gradient_1: "#5245C5", color_gradient_2: "#61A8FB", description: "Agir en société", name: "energy"))
        themas.append(Thema(color_gradient_1: "#5245C5", color_gradient_2: "#61A8FB", description: "Agir en société", name: "mobility"))
        themas.append(Thema(color_gradient_1: "#F95A7D", color_gradient_2: "#F288E1", description: "Mangez mieux", name: "eat"))

        // à virer quand on aura le service retrieveChallenges
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
        })

        // à virer quand on aura le service retrieveLevels
        LevelService.instance.getAllLevels { (levels) in
            self.levels = levels
        }

        // Add delegate to self to use native function table View
        tableView.delegate = self
        tableView.dataSource = self
        headerProgressView.setProgress(0, animated: false)
        self.navigationController?.isNavigationBarHidden = true

        retrieveCurrentLevel()
    }

    // set progress bar and set currentLevel
    func retrieveCurrentLevel () {
        var totalLevelPoint = 0
        var precedentTotalPoints = 0

        levels.forEach { (level) in
            if ((level.required + totalLevelPoint) > self.userPoints && precedentTotalPoints < self.userPoints) {
                remainingPoints = (level.required + totalLevelPoint) - userPoints
                let progressInLevel = level.required - remainingPoints

                self.currentLevel = level
                self.minValue = progressInLevel
                self.maxValue = level.required

                headerProgressView.progress = Float(minValue) / Float(maxValue)

                levelLabel.text = String("Niveau \(level.name)")
                remainingPointsLabel.text = "Encore \(remainingPoints) points"
            }

            precedentTotalPoints = level.required + totalLevelPoint
            totalLevelPoint += level.required
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.isNavigationBarHidden = false
    }
}

extension ChallengesViewController: CellProgressDelegate {
    func didChangeChallengeCompleteMissions(value: Int) {

    }

    func didCompleteChallenge(_ challenge: ChallengeRun) {
        self.xpMore = challenge.points
        self.remainingPointsLabel.text = "\(remainingPoints)"

        if let index = challenges_user.index(where: { $0.challenge_id == challenge.challenge_id }) {
            challenges_user.remove(at: index)
            let indexPath = IndexPath(item: index + 1, section: 0)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }

        self.startDownload()
    }
}

extension ChallengesViewController: FilterChallengeDelegate {
    func didFilterBy(type: String) {
        self.challenges_user = allChallengesUser.filter({$0.repetition_type == type})
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
            print("clicked")
            if let detailChallengeView =
                self.storyboard?.instantiateViewController(withIdentifier: "detailChallengeViewControllerIdentifier") as? DetailChallengeViewController {
                print("inner clicked")
                let currentCell = tableView.cellForRow(at: indexPath)
                let challenge = challenges_user[indexPath.row - 1]
                
                print(challenge, "challenge")
                
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

