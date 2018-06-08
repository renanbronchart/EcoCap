//
//  OnBoardingContainerViewController.swift
//  EcoCap
//
//  Created by Renan Bronchart on 26/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class OnBoardingContainerViewController: UIViewController {

    @IBOutlet weak var containerOnboarding: UIView!
    @IBOutlet weak var pageControlOnboarding: UIPageControl!
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "USERLOGGEDIN") == true {
            print("CONNECTED")
            self.redirectToChallengeViewStoryboard()
            
        }
    }
    
    private func redirectToChallengeViewStoryboard() {
        var homeStoryboard: UIStoryboard!
        homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        
        if let challengesViewcontroller = homeStoryboard.instantiateViewController(withIdentifier: "homeTapBarControllerIdentifier") as? UITabBarController {
            self.present(challengesViewcontroller, animated: true, completion: nil)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let onboardingViewController = segue.destination as? OnboardingViewController {
            onboardingViewController.onboardingDelegate = self
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func goToLoginPage(_ sender: Any) {
        var AuthStoryboard: UIStoryboard!
        
        AuthStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        
        if let authViewController = AuthStoryboard.instantiateViewController(withIdentifier: "loginIdentifier") as? AuthViewController {
            self.present(authViewController, animated: true, completion: nil)
        }
    }
}

extension OnBoardingContainerViewController: OnboardingViewControllerDelegate {
    func onboardingViewController(onboardingViewController: OnboardingViewController, didUpdatePageCount count: Int) {
        pageControlOnboarding.numberOfPages = count
    }
    
    func onboardingViewController(onboardingViewController: OnboardingViewController, didUpdatePageIndex index: Int) {
        pageControlOnboarding.currentPage = index
    }
}
