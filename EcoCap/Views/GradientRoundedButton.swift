//
//  GradientRoundedButton.swift
//  EcoCap
//
//  Created by Renan Bronchart on 28/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class GradientRoundedButton: UIButton {
    private var gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 0
        layer.cornerRadius = 20
        clipsToBounds = true
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        updateView()
    }
    
    
    func updateView () {
        // Fill view with gradient layer
        gradientLayer.frame = self.bounds
        
        // Style layer
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint (x: 1, y: 0.5)
        
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        
        gradientLayer.locations = [0.0, 1.0]
        
        // Insert layer if not already inserted
        if gradientLayer.superlayer == nil {
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.colors = isEnabled ? [firstColor.cgColor, secondColor.cgColor] : [UIColor.lightGray.cgColor, UIColor.lightGray.cgColor]
        self.titleLabel?.textColor = isEnabled ? UIColor.white : UIColor(displayP3Red: 218/255, green: 218/255, blue: 218/255, alpha: 1)
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
}
