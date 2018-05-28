//
//  HeaderStickyView.swift
//  EcoCap
//
//  Created by Renan Bronchart on 27/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class HeaderStickyView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // ça ne fonctionne pas
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 400, height: 15)
        layer.shadowRadius = 10
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
    }
    
    public func decrementLabelAlpha (label: UILabel, offset: CGFloat) {
        if label.alpha <= 1 {
            let alphaOffset = max((offset - 65) / 85.0, 0)
            
            label.alpha += alphaOffset
        }
    }
    
    public func incrementLabelAlpha (label: UILabel, offset: CGFloat) {
        if label.alpha >= 0.1 {
            let alphaOffset = (offset / 100) / 85
            
            label.alpha -= alphaOffset
        }
    }
}

