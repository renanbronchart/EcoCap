//
//  LevelService.swift
//  EcoCap
//
//  Created by Bourgoin Théo on 07/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import Foundation
import FirebaseFirestore

class LevelService {
    
    static let instance = LevelService()
    var db: Firestore

    private init() {
        self.db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    // Retrieve all levels
    func getAllLevels(callback: @escaping ([Level]) -> Void) {
        var levels = [Level]()
        self.db.collection("level").getDocuments() { querySnapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                levels = querySnapshot!.documents.compactMap({Level(dictionary: $0.data())})
                callback(levels)
            }
        }
    }
}
