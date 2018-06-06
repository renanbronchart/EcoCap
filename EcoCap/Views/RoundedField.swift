//
//  File.swift
//  EcoCap
//
//  Created by Wladimir Delenclos on 07/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//
//

import UIKit

class RoundedField: UITextField {
    private var gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 0
        layer.cornerRadius = 40
        clipsToBounds = true
      
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        updateView()
    }
    
    override var isSelected: Bool {
        willSet {
            
        }
        
        didSet {
            updateView()
        }
    }
    
    
    func updateView () {
        // Fill view with gradient layer
        gradientLayer.frame = self.bounds
        
        // Style layer
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint (x: 1, y: 0.5)
        
        if selectable {
            gradientLayer.colors = isSelected ? [firstColor.cgColor, secondColor.cgColor] : [noSelectedColor.cgColor, noSelectedColor.cgColor]
        } else {
            gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        }
        
        self.titleLabel?.textColor = UIColor.white
        gradientLayer.locations = [0.0, 1.0]
        
        // Insert layer if not already inserted
        if gradientLayer.superlayer == nil {
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if selectable {
            gradientLayer.colors = isSelected ? [firstColor.cgColor, secondColor.cgColor] : [noSelectedColor.cgColor, noSelectedColor.cgColor]
        } else {
            gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        }
        
        self.titleLabel?.textColor = UIColor.white
        
        self.titleLabel?.textColor = isEnabled ? UIColor.white : UIColor(displayP3Red: 218/255, green: 218/255, blue: 218/255, alpha: 1)
    }
    
    @IBInspectable var selectable: Bool = false {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var noSelectedColor: UIColor = UIColor.clear {
        didSet {
            updateView()
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
}
