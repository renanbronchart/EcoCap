//
//  Challenge.swift
//  EcoCap
//
//  Created by Renan Bronchart on 30/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//


import Foundation
import FirebaseFirestore

protocol DocumentSerializable {
    init?(dictionary:[String: Any])
}

struct Challenge {

    var name: String
    var description: String
    var value: Int
    var repetition: Int
    var repetition_type: String
    var thema: String
    var level: Int
    
    var dictionary:[String:Any] {
        return [
            "name": name,
            "description": description,
            "value": value,
            "repetition": repetition,
            "repetition_type": repetition_type,
            "thema": thema,
            "level": level
        ]
    }
}

extension Challenge: DocumentSerializable {
    init?(dictionary:[String:Any]) {
        guard let name = dictionary["name"] as? String, let description = dictionary["description"] as? String, let value = dictionary["points"] as? Int, let repetition = dictionary["repetition"] as? Int, let repetition_type = dictionary["repetition_type"] as? String, let thema = dictionary["thema"] as? String, let level = dictionary["level"] as? Int else { return nil }
        
        self.init(name: name, description: description, value: value, repetition: repetition, repetition_type: repetition_type, thema: thema, level: level)
    }
}
