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
    
    @IBOutlet weak var startButton: UIButton!
    //    @IBOutlet weak var customHeaderHeightConstraint: NSLayoutConstraint!
//    
//    @IBOutlet weak var customHeaderView: CustomHeaderView!
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var colorView: UIView!
//    @IBOutlet weak var headerImageView: UIImageView!
//    
//    @IBOutlet weak var purcentNumber: UILabel!
//    @IBOutlet weak var downloadBar: UIProgressView!
//    
//    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func startDownload(_ sender: Any) {
        startButton.isEnabled = false
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
                startButton.isEnabled = true
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ChallengesViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "challengesTableViewCellIdentifier") as! ChallengesTableViewCell
        
        cell.challenge = challenges[row]
        
        return cell
    }
}

extension ChallengesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section != 0 {
            return nil
        }
        
        let add = UIContextualAction(style: .normal, title: "Add") { (action, view, nil) in
            print("Accept")
        }
        
        add.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        add.image = #imageLiteral(resourceName: "add")
        
        let waitlist = UIContextualAction(style: .normal, title: "Waitlist") { (action, view, nil) in
            print("Waitlist")
        }
        
        waitlist.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        
        let config = UISwipeActionsConfiguration(actions: [add, waitlist])
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete") { (action, view, nil) in
            print("Delete")
        }
        
        delete.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        
        let rejected = UIContextualAction(style: .normal, title: "rejected") { (action, view, nil) in
            print("Waitlist")
        }
        
        rejected.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        
        let config = UISwipeActionsConfiguration(actions: [delete, rejected])
        config.performsFirstActionWithFullSwipe = false
        
        return config
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
            
            print(self.headerStickyHeightConstraint, "< 0")
            self.headerStickyHeightConstraint.constant += abs(scrollView.contentOffset.y)
            
            self.progressViewTopConstraint.constant += abs(scrollView.contentOffset.y)

             headerStickyView.decrementLabelAlpha(label: titleHeaderStickyLabel, offset: headerStickyHeightConstraint.constant)
            
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
        if self.headerStickyHeightConstraint.constant > 250 {
            self.headerStickyHeightConstraint.constant = 250
        }
        
        if self.headerStickyHeightConstraint.constant > 110 {
            animateHeader()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.headerStickyHeightConstraint.constant > 250 {
            self.headerStickyHeightConstraint.constant = 250
        }
        
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

