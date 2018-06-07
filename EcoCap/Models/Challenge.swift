//
//  Challenge.swift
//  EcoCap
//
//  Created by Renan Bronchart on 30/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import Foundation

protocol DocumentSerializable {
    init?(dictionary:[String: Any])
}

struct Challenge {
    var uid: String
    var name: String
    var description: String
    var points: Int
    var repetition: Int
    var repetition_type: String
    var repetition_name: String
    var type: String
    var level: Int
    var short_description: String

    var dictionary:[String: Any] {
        return [
            "uid": uid,
            "name": name,
            "description": description,
            "points": points,
            "repetition": repetition,
            "repetition_type": repetition_type,
            "repetition_name": repetition_name,
            "type": type,
            "level": level,
            "short_description": short_description,
        ]
    }
}

extension Challenge: DocumentSerializable {
    init?(dictionary:[String: Any]) {
        guard let uid = dictionary["uid"] as? String, let name = dictionary["name"] as? String, let description = dictionary["description"] as? String, let points = dictionary["points"] as? Int, let repetition = dictionary["repetition"] as? Int, let repetition_type = dictionary["repetition_type"] as? String, let repetition_name = dictionary["repetition_name"] as? String, let type = dictionary["type"] as? String, let level = dictionary["level"] as? Int, let short_description = dictionary["short_description"] as? String else { return nil }

        self.init(uid: uid, name: name, description: description, points: points, repetition: repetition, repetition_type: repetition_type, repetition_name: repetition_name, type: type, level: level, short_description: short_description)

    }
}
