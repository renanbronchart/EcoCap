//
//  ChallengesViewController.swift
//  EcoCap
//
//  Created by Renan Bronchart on 26/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class ChallengesViewController: UIViewController {
    
    let challenges = ["Toilette de chat", "Thé ou café", "Le bobo bio", "A vélo on dépasse les auto", "Deux degré de moins", "Deux degré de moins", "Deux degré de moins", "Deux degré de moins", "Deux degré de moins", "Deux degré de moins"]
    
    var minValue = 0
    var maxValue = 100
    var xpMore = 10
    var more: Int = 0
    var downloader = Timer()
//    private var lastContentOffset: CGFloat = 0
    
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
    
    func startDownload(_ sender: Any) {
        more = minValue + xpMore
        downloader = Timer.scheduledTimer(timeInterval: 0.06, target: self, selector: (#selector(self.updater)), userInfo: nil, repeats: true)
    }
    
    @objc func updater () {
        if minValue != maxValue {
            if minValue != more {
                minValue += 1
                remainingPointsLabel.text = "\(minValue)"
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
        
        tableView.delegate = self
        tableView.dataSource = self
        headerProgressView.setProgress(0, animated: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
//
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTableViewCellIdentifier") as! CategoryTableViewCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "challengesTableViewCellIdentifier") as! ChallengesTableViewCell
            
            cell.challenge = challenges[row - 1]
            
            return cell
        }
    }
}

extension ChallengesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        // If move up
//        if (self.lastContentOffset > scrollView.contentOffset.y) {
//            print("move up")
//        }
//        else if (self.lastContentOffset < scrollView.contentOffset.y) {
//            print("move down")
//        }

        // update the new position acquired
//        self.lastContentOffset = scrollView.contentOffset.y
        
        if (scrollView.contentOffset.y < 0) {
            if (self.headerStickyHeightConstraint.constant > 110) {
                animateHeader()
            } else {
                self.headerStickyHeightConstraint.constant += abs(scrollView.contentOffset.y)
                
                self.progressViewTopConstraint.constant += abs(scrollView.contentOffset.y)
                
                headerStickyView.decrementLabelAlpha(label: titleHeaderStickyLabel, offset: headerStickyHeightConstraint.constant)
            }
            
        } else if (scrollView.contentOffset.y > 0) {
            print(self.headerStickyHeightConstraint, "> = 80")
            
            if (self.headerStickyHeightConstraint.constant >= 80) {
                self.headerStickyHeightConstraint.constant -= scrollView.contentOffset.y / 104
            }
            
            if (self.progressViewTopConstraint.constant >= 16) {
                self.progressViewTopConstraint.constant -= scrollView.contentOffset.y / 104
            }

            headerStickyView.incrementLabelAlpha(label: titleHeaderStickyLabel, offset: headerStickyHeightConstraint.constant)
        }
        
        if self.headerStickyHeightConstraint.constant < 80 {
            print("< 80")
            self.headerStickyHeightConstraint.constant = 80
        }
        
        if self.progressViewTopConstraint.constant < 16 {
            self.progressViewTopConstraint.constant = 16
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if self.headerStickyHeightConstraint.constant > 250 {
//            self.headerStickyHeightConstraint.constant = 250
//        }
        
        if self.headerStickyHeightConstraint.constant > 110 {
            animateHeader()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if self.headerStickyHeightConstraint.constant > 250 {
//            self.headerStickyHeightConstraint.constant = 250
//        }
        
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

