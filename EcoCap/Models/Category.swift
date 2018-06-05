//
//  Category.swift
//  EcoCap
//
//  Created by Bourgoin Théo on 04/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import Foundation

class Category {
    var name: String
    var icon: String
    var gradient_color_1: String
    var gradient_color_2: String
    
    init(name: String, icon: String, gradient_color_1: String, gradient_color_2: String) {
        self.name = name
        self.icon = icon
        self.gradient_color_1 = gradient_color_1
        self.gradient_color_2 = gradient_color_2
    }
}
