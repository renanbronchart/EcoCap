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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let onboardingViewController = segue.destination as? OnboardingViewController {
            onboardingViewController.onboardingDelegate = self
        }
    }
}

extension OnBoardingContainerViewController: OnboardingViewControllerDelegate {
    func onboardingViewController(onboardingViewController: OnboardingViewController, didUpdatePageCount count: Int) {
        print(count)
        pageControlOnboarding.numberOfPages = count
    }
    
    func onboardingViewController(onboardingViewController: OnboardingViewController, didUpdatePageIndex index: Int) {
        print(index)
        pageControlOnboarding.currentPage = index
    }
}
