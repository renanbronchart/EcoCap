//
//  LevelService.swift
//  EcoCap
//
//  Created by Bourgoin Théo on 06/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import Foundation
import FirebaseFirestore

class LevelService {
    var db:Firestore!
    var levelArray = [Level]()
    static let instance = LevelService()
    
    private init() {
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    
    // Retrieve levels
    func getLevels(callback: @escaping ([Level]) -> Void) {
        db.collection("level").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                self.levelArray = querySnapshot!.documents.compactMap({Level(dictionary: $0.data())})
            }
            callback(self.levelArray)
        }
    }
}
