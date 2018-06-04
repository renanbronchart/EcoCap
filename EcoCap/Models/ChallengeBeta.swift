//
//  ChallengeBeta.swift
//  EcoCap
//
//  Created by Renan Bronchart on 30/05/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import Foundation
//import SwiftyJSON

class ChallengeBeta {
    var type: String!
    var name: String!
    var short_description: String!
    var description: String!
    var total_missions: Int!
    var complete_missions: Int!
    var name_mission: String!
    var value: Int!
    
    init(name: String,
         type: String,
         short_description: String,
         description: String,
         total_missions: Int,
         complete_missions: Int,
         name_mission: String,
         value: Int
    ) {
        self.type = type
        self.name = name
        self.short_description = short_description
        self.description = description
        self.total_missions = total_missions
        self.complete_missions = complete_missions
        self.name_mission = name_mission
        self.value = value
    }
}


//// Extension pour le parsing Json, n'importe où dans notre projet
//extension Episode {
//    // convenience ne pas ecraser le constructeur par défault
//    convenience init(json: JSON) {
//        self.init()
//
//        self.name = json["name"].stringValue
//        self.summary = json["summary"].stringValue
//
//        self.season = json["season"].intValue
//        self.season = json["number"].intValue
//
//        let thumbnailUrl = json["image"]["medium"].stringValue
//
//        self.thumbnail = thumbnailUrl.replacingOccurrences(of: "http://", with: "https://")
//
//        let image = json["image"]["original"].stringValue
//
//        self.bigImage = image.replacingOccurrences(of: "http://", with: "https://")
//    }
//}

