//
//  overrideUIImage.swift
//  EcoCap
//
//  Created by Renan Bronchart on 06/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
extension UIImageView {
    open override func draw(_ rect: CGRect) {
        self.clipsToBounds = true
    }
}
