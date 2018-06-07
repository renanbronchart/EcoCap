//
//  CustomField.swift
//  EcoCap
//
//  Created by Wladimir Delenclos on 07/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//


import UIKit

@IBDesignable
class CustomField: UITextField {

    @IBInspectable var imageSrc: UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 0
        self.layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.leftView = UIImageView(image: imageSrc)
    }
}
