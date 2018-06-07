//
//  GradientView.swift
//  AppHeti-c
//
//  Created by Renan Bronchart on 26/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    private var gradientLayer = CAGradientLayer()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        updateView()
    }
    
    func updateView () {
        // Fill view with gradient layer
        gradientLayer.frame = self.bounds
        
        // Style layer
        if (self.isHorizontal) {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint (x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint (x: 0.5, y: 1)
        }
        
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        
        gradientLayer.locations = [0.0, 1.0]
        
        self.clipsToBounds = true
        
        // Insert layer if not already inserted
        if gradientLayer.superlayer == nil {
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    @IBInspectable var firstColor: UIColor = UIColor.clear {
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
}
