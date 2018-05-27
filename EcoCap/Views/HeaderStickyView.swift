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
    
    public func decrementViewAlpha (view: UIView, offset: CGFloat) {
        if view.alpha <= 1 {
            let alphaOffset = (offset / 500) / 85
            
            view.alpha += alphaOffset
        }
    }
    
    public func decrementImageAlpha(imageView: UIImageView, offset: CGFloat) {
        if imageView.alpha >= 0 {
            let alphaOffset = max((offset - 65) / 85.0, 0)
            
            imageView.alpha = alphaOffset
        }
    }
    
    public func incrementViewAlpha (view: UIView, offset: CGFloat) {
        if view.alpha >= 0.45 {
            let alphaOffset = (offset / 200) / 85
            
            view.alpha -= alphaOffset
        }
    }
    
    public func incrementImageAlpha(imageView: UIImageView, offset: CGFloat) {
        if imageView.alpha <= 1 {
            let alphaOffset = max((offset - 65) / 85.0, 0)
            
            imageView.alpha = alphaOffset
        }
    }
}

