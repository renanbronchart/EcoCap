//
//  ChallengeRun.swift
//  EcoCap
//
//  Created by Bourgoin Théo on 06/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import Foundation

struct ChallengeRun {
    var challenge_id: String
    var name: String
    var description: String
    var points: Int
    var repetition: Int
    var repetition_type: String
    var repetition_name: String
    var type: String
    var level: Int
    var short_description: String
    var repetition_completed: Int
    var completed: Bool
    var user_id: String

    var dictionary:[String: Any] {
        return [
            "challenge_id": challenge_id,
            "name": name,
            "description": description,
            "points": points,
            "repetition": repetition,
            "repetion_completed": repetition_completed,
            "repetition_type": repetition_type,
            "repetition_name": repetition_name,
            "type": type,
            "level": level,
            "short_description": short_description,
            "completed": completed,
            "user_id": user_id
        ]
    }
}

extension ChallengeRun: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let challenge_id = dictionary["challenge_id"] as? String, let name = dictionary["name"] as? String, let description = dictionary["description"] as? String, let points = dictionary["points"] as? Int, let repetition = dictionary["repetition"] as? Int, let repetition_type = dictionary["repetition_type"] as? String, let repetition_name = dictionary["repetition_name"] as? String, let type = dictionary["type"] as? String, let level = dictionary["level"] as? Int, let short_description = dictionary["short_description"] as? String, let repetition_completed = dictionary["repetition_completed"] as? Int, let completed = dictionary["completed"] as? Bool, let user_id = dictionary["user_id"] as? String else { return nil }

        self.init(challenge_id: challenge_id, name: name, description: description, points: points, repetition: repetition, repetition_type: repetition_type, repetition_name: repetition_name, type: type, level: level, short_description: short_description, repetition_completed: repetition_completed, completed: completed, user_id: user_id)
    }
}
