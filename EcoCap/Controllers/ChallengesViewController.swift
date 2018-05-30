//
//  ChallengesViewController.swift
//  EcoCap
//
//  Created by Renan Bronchart on 26/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class ChallengesViewController: UIViewController {
    
//    let challenges = ["Toilette de chat", "Thé ou café", "Le bobo bio", "A vélo on dépasse les auto", "Deux degré de moins", "Deux degré de moins", "Deux degré de moins", "Deux degré de moins", "Deux degré de moins", "Deux degré de moins"]
    
    lazy var challenges = [ChallengeBeta]()
    
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

        
        // à virer quand on aura le service
        challenges.append(ChallengeBeta(name: "Toilette de chat", type: "Préserver l'eau", short_description: "Ne prenez plus de bain pendant un mois", description: "Remplacer votre bain par une douche à la durée modérée vous permet d’économiser près de 30% de votre consommation d’eau et 11% de votre chauffage. Un sacré défi pour commencer !", total_missions: 10, complete_missions: 0, name_mission: "douche", value: 1000))
        challenges.append(ChallengeBeta(name: "Thé ou café ?", type: "Manger mieux", short_description: "Changez votre tasse de café par du thé une fois par jour.", description: "Pour produire 125ml de café, 140 litres d’eau sont nécessaires, alors que seulement 17 sont nécessaires pour du thé. En plus, on a une légère tendance à menacer la forêt tropicale pour notre café, alors deux raisons pour le prix d’une ! Le bobo bio Acheter bio une fois par semaine, c’est peut être bobo, mais c’est la garantie de manger des produits plus respectueux pour l’environnement et meilleurs à la santé !", total_missions: 25, complete_missions: 0, name_mission: "Thé", value: 800))
        challenges.append(ChallengeBeta(name: "Monte en selle", type: "Mobilité", short_description: "Rends toi au boulot en vélo", description: "A vélo on dépasse les auto Remplacez un moyen de transport journalier par de la marche ou du vélo, ce n’est pas si long et c’est bon pour la forme, et pour la planète ...", total_missions: 10, complete_missions: 0, name_mission: "trajets", value: 1800))
        
        tableView.delegate = self
        tableView.dataSource = self
        headerProgressView.setProgress(0, animated: false)
        self.navigationController?.isNavigationBarHidden = true
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("clicked")
        if let detailChallengeView =
            self.storyboard?.instantiateViewController(withIdentifier: "detailChallengeViewControllerIdentifier") as? DetailChallengeViewController {
            
            detailChallengeView.challenge =  challenges[indexPath.row - 1]
            
            self.navigationController?.pushViewController(detailChallengeView, animated: true)
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

