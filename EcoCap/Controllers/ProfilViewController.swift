//
//  ProfilViewController.swift
//  EcoCap
//
//  Created by Renan Bronchart on 04/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

struct Section {
    var type: String
    var belonging: [String]
}

class ProfilViewController: UIViewController {

    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var challengeCompletedLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var levelNameLabel: UILabel!
    @IBOutlet weak var remainingPointsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        let today = Section(type: "Aujourd'hui", belonging: ["Cat", "Dog", "Lion"])
        let week = Section(type: "Cette semaine", belonging: ["Bat", "plop", "plpi", "plop"])
        let month = Section(type: "Le mois dernier", belonging: ["Bat", "plop", "plpi", "plop"])
        
        sections.append(today)
        sections.append(week)
        sections.append(month)
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 139
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()

        view.backgroundColor = UIColor.white
        
        return view
    }
}