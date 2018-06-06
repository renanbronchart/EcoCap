//
//  UserBeta.swift
//  EcoCap
//
//  Created by Renan Bronchart on 06/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import Foundation

class UserBeta {
    var name: String!
    var score: Int!
    var challenge_list: [ChallengeRun]?
    
    init(name: String,
         score: Int,
         challenge_list: [ChallengeRun]
        ) {
        self.score = score
        self.name = name
        self.challenge_list = challenge_list
    }
}
