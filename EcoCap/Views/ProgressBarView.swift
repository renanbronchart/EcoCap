//
//  AppProgressView.swift
//  AppHeti-c
//
//  Created by Renan Bronchart on 25/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class ProgressBarView: UIProgressView {
    
    // Update immediatly each subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maskLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.height)
        let maskLayer = CAShapeLayer()
        let spaceProgress = borderWidth * 2
        
        maskLayer.frame = self.bounds
        maskLayer.path = maskLayerPath.cgPath
        layer.mask = maskLayer
        
        layer.borderWidth = borderWidth
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = self.frame.height / 2
        
        self.subviews[1].clipsToBounds = true
        
        // progress
        subviews[1].layer.cornerRadius = (self.frame.height / 2) - spaceProgress
        subviews[1].layer.borderWidth = 4
        subviews[1].layer.frame = subviews[1].layer.frame.insetBy(dx: spaceProgress, dy: spaceProgress)
        subviews[1].layer.borderColor = UIColor(displayP3Red: 255, green: 255, blue: 255, alpha: 0).cgColor
        
        layer.sublayers![1].borderWidth = 0
        layer.sublayers![1].borderColor = UIColor.white.cgColor
        
        setColorGradient()
    }
    
    func setColorGradient () {
        let gradientLayer = CAGradientLayer()
        
        if (self.isHorizontal) {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint (x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint (x: 0.5, y: 1)
        }
        
        gradientLayer.colors = [firstColor, secondColor].map{$0.cgColor}
        
        gradientLayer.frame = subviews[1].bounds
        
        subviews[1].layer.addSublayer(gradientLayer)
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }
    
    func updateView () {
        self.setColorGradient()
    }
}
