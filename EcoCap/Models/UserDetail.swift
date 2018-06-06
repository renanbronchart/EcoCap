//
//  UserService.swift
//  EcoCap
//
//  Created by Bourgoin Théo on 05/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import Foundation

struct UserDetail {
    
    var name: String
    var score: Int
    var uid: String
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "score": score,
            "uid": uid,
        ]
    }
    
}

extension UserDetail: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String, let score = dictionary["score"] as? Int, let uid = dictionary["uid"] as? String else { return nil }
        
        self.init(name: name, score: score, uid: uid)
    }
}
