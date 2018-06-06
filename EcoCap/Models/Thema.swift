//
//  Category.swift
//  EcoCap
//
//  Created by Bourgoin Théo on 04/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Thema {
    var name: String
    var icon: String
    var desc: String
    var gradient_color_1: String
    var gradient_color_2: String
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "icon": icon,
            "desc": desc,
            "gradient_color_1": gradient_color_1,
            "gradient_color_2": gradient_color_2
        ]
    }
}

extension Thema: DocumentSerializable {
    init?(dictionary:[String:Any]) {
        guard let name = dictionary["name"] as? String, let icon = dictionary["icon"] as? String, let desc = dictionary["desc"] as? String, let gradient_color_1 = dictionary["gradient_color_1"] as? String, let gradient_color_2 = dictionary["gradient_color_2"] as? String else { return nil }
        
        self.init(name: name, icon: icon, desc: desc, gradient_color_1: gradient_color_1, gradient_color_2: gradient_color_2)
    }
}
