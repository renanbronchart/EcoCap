//
//  UserDetail.swift
//  EcoCap
//
//  Created by Bourgoin Théo on 07/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import Foundation

struct UserDetail {
    var challenges_ids: [String]
    var level: Int
    var name: String
    var score: Int
    var user_id: String
    
    var dictionary: [String: Any] {
        return [
            "challenges_ids": challenges_ids,
            "level": level,
            "name": name,
            "score": score,
            "user_id": user_id
        ]
    }
    
}

extension UserDetail: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let challenges_ids = dictionary["challenges_ids"] as? [String], let level = dictionary["level"] as? Int, let name = dictionary["name"] as? String, let score = dictionary["score"] as? Int, let user_id = dictionary["user_id"] as? String else { return nil }
        
        self.init(challenges_ids: challenges_ids, level: level, name: name, score: score, user_id: user_id)
    }
}
