//
//  CustomTabBarViewController.swift
//  EcoCap
//
//  Created by Renan Bronchart on 06/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let allItems:[AnyObject] = self.tabBar.items!
        
        let rankingTabButton:UITabBarItem = allItems[0] as! UITabBarItem
        let profileTabButton:UITabBarItem = allItems[1] as! UITabBarItem
        let challengeTabButton:UITabBarItem = allItems[1] as! UITabBarItem
        
        
        rankingTabButton.image = UIImage(named: "icn_ranking")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        profileTabButton.image = UIImage(named: "icn_challenge")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        challengeTabButton.image = UIImage(named: "icn_profile")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        rankingTabButton.selectedImage = UIImage(named: "icn_ranking")
        profileTabButton.selectedImage = UIImage(named: "icn_profile")
        challengeTabButton.selectedImage = UIImage(named: "icn_challenge")
        
        // Do any additional setup after loading the view.
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
