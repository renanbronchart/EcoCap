//
//  ChallengesViewController.swift
//  EcoCap
//
//  Created by Renan Bronchart on 26/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class ChallengesViewController: UIViewController {
    
    lazy var challenges = [Challenge]()
    lazy var levels = [Level]()
    
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
        print("Start value")
        more = minValue + xpMore
        downloader = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: (#selector(self.updater)), userInfo: nil, repeats: true)
    }
    
    @objc func updater () {
        if minValue != maxValue {
            if minValue != more {
                minValue += 1
                headerProgressView.progress = Float(minValue) / Float(maxValue)
            } else {
                downloader.invalidate()
            }
        } else {
            minValue = 0
            more = minValue
            print("Niveau suivant")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LevelService.instance.getLevels { (levelArray) in
            self.levels = levelArray
        }
        ChallengeService.instance.getChallenges { (challenges) in
            self.challenges = challenges
            
            // Refresh UI de la tableView 👍
            self.tableView.reloadData()
        }
        print(self.challenges)
        userPoints = 11500
        
        // à virer quand on aura le service retrieveLevels
        
        
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
    
    func didCompleteChallenge(value: Int) {
        self.xpMore = value
        self.remainingPointsLabel.text = "\(remainingPoints)"
        
        self.startDownload()
    }
}

extension ChallengesViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "challengesTableViewCellIdentifier") as! ChallengesTableViewCell
            
            cell.challenge = challenges[row - 1]
            
            cell.delegate = self
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
        } else {
            if let detailChallengeView =
                self.storyboard?.instantiateViewController(withIdentifier: "detailChallengeViewControllerIdentifier") as? DetailChallengeViewController {
                let currentCell = tableView.cellForRow(at: indexPath)
                
                detailChallengeView.delegate = currentCell as? ChallengeDetailDelegate
                    
                detailChallengeView.challenge =  challenges[indexPath.row - 1]
                
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

