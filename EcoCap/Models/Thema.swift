//
//  Thema.swift
//  EcoCap
//
//  Created by Renan Bronchart on 07/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import Foundation

class Thema {
    var color_gradient_1: String!
    var color_gradient_2: String!
    var description: String!
    var name: String!

    init(color_gradient_1: String,
         color_gradient_2: String,
         description: String,
         name: String
        ) {
        self.color_gradient_1 = color_gradient_1
        self.color_gradient_2 = color_gradient_2
        self.description = description
        self.name = name
    }
}
