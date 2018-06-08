//
//  OnboardingViewController.swift
//  EcoCap
//
//  Created by Renan Bronchart on 25/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

// Need to declare the type of the protocol as class
protocol OnboardingViewControllerDelegate: class {
    // Called when the number of pages is updated.
    func onboardingViewController(onboardingViewController: OnboardingViewController,
                                  didUpdatePageCount count: Int)
    
    
    // Called when the current index is updated.
    func onboardingViewController(onboardingViewController: OnboardingViewController,
                                  didUpdatePageIndex index: Int)
    
}

class OnboardingViewController: UIPageViewController {
    
    weak var onboardingDelegate: OnboardingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        onboardingDelegate?.onboardingViewController(onboardingViewController: self, didUpdatePageCount: orderedViewControllers.count)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newPageViewController(page: "pageOne"),
                self.newPageViewController(page: "pageTwo"),
                self.newPageViewController(page: "pageThree")]
    }()
    
    private func newPageViewController(page: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(page)OnboardingViewIdentifier")
    }

}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.index(of: firstViewController) {
            onboardingDelegate?.onboardingViewController(onboardingViewController: self, didUpdatePageIndex: index)
        }
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
//        // To loop effect
//        guard previousIndex >= 0 else {
//            return orderedViewControllers.last
//        }
        
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
//        // To loop effect
//        guard orderedViewControllersCount != nextIndex else {
//            return orderedViewControllers.first
//        }
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    
}
