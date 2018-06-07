//
//  Thema.swift
//  EcoCap
//
//  Created by Renan Bronchart on 07/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import Foundation

struct Thema {
    var color_gradient_1: String
    var color_gradient_2: String
    var description: String
    var name: String
    var icon: String

    var dictionary: [String: Any] {
        return [
            "color_gradient_1": color_gradient_1,
            "color_gradient_2": color_gradient_2,
            "description": description,
            "name": name,
            "icon": icon
        ]
    }
}

extension Thema: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let color_gradient_1 = dictionary["color_gradient_1"] as? String, let color_gradient_2 = dictionary["color_gradient_1"] as? String, let description = dictionary["description"] as? String, let name = dictionary["name"] as? String, let icon = dictionary["icon"] as? String else { return nil }
        self.init(color_gradient_1: color_gradient_1, color_gradient_2: color_gradient_2, description: description, name: name, icon: icon)
    }
}
