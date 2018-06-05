//
//  ChallengeRun.swift
//  EcoCap
//
//  Created by Bourgoin Théo on 05/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import Foundation

struct ChallengeRun {
    
    var challenge_id: String
    var completed: Bool
    var end_at: Date
    var start_at: Date
    var user_id: String
    
    var dictionary:[String: Any] {
        return [
            "challenge_id": challenge_id,
            "completed": completed,
            "end_at": end_at,
            "start_at": start_at,
            "user_id": user_id
        ]
    }
}

extension ChallengeRun: DocumentSerializable {
    init?(dictionary:[String: Any]) {
        guard let challenge_id = dictionary["challenge_id"] as? String, let completed = dictionary["completed"] as? Bool, let end_at =  dictionary["end_at"] as? Date, let start_at = dictionary["start_at"] as? Date, let user_id = dictionary["user_id"] as? String else { return nil }
        
        self.init(challenge_id: challenge_id, completed: completed, end_at: end_at, start_at: start_at, user_id: user_id)
    }
}
