//
//  Level.swift
//  EcoCap
//
//  Created by Renan Bronchart on 30/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import Foundation

struct Level {
    var name: String
    var number: Int
    var required: Int
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "number": number,
            "required": required
        ]
    }
}

extension Level: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String, let number = dictionary["number"] as? Int, let required = dictionary["required"] as? Int else { return nil }
        
        self.init(name: name, number: number, required: required)
    }
}
