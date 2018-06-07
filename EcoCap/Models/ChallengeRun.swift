//
//  ChallengeRun.swift
//  EcoCap
//
//  Created by Renan Bronchart on 06/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import Foundation

class ChallengeRun {
    var uid: String!
    var name: String!
    var description: String!
    var points: Int!
    var repetition: Int!
    var repetition_type: String!
    var repetition_name: String!
    var type: String!
    var level: Int!
    var short_description: String!
    var repetition_completed: Int?
    var completed: Bool?
    var start_at: Date?
    var end_at: Date?
    
    init(uid: String,
         name: String,
         description: String,
         points: Int,
         repetition: Int,
         repetition_type: String,
         repetition_name: String,
         type: String,
         level: Int,
         short_description: String,
         repetition_completed: Int? = nil,
         completed: Bool? = nil,
         start_at: Date? = nil,
         end_at: Date? = nil
        ) {
        self.uid = uid
        self.name = name
        self.description = description
        self.points = points
        self.repetition = repetition
        self.repetition_completed = repetition_completed
        self.repetition_type = repetition_type
        self.repetition_name = repetition_name
        self.type = type
        self.level = level
        self.short_description = short_description
        self.completed = completed
        self.start_at = start_at
        self.end_at = end_at
    }
}
