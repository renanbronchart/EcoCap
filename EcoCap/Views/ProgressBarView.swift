//
//  AppProgressView.swift
//  AppHeti-c
//
//  Created by Renan Bronchart on 25/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class ProgressBarView: UIProgressView {
    override func layoutSubviews() {
        super.layoutSubviews()
    
        let maskLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.height)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskLayerPath.cgPath
        layer.mask = maskLayer
        
        layer.borderWidth = 3
        layer.borderColor = UIColor.white.cgColor
        
        layer.sublayers![1].cornerRadius = self.frame.height / 2
        self.subviews[1].clipsToBounds = true
        
        layer.sublayers![1].borderWidth = 3
        layer.sublayers![1].borderColor = UIColor.white.cgColor
    }
}
