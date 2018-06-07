//
//  ThemaService.swift
//  EcoCap
//
//  Created by Bourgoin Théo on 07/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import Foundation
import FirebaseFirestore

class ThemaService {
    
    static let instance = ThemaService()
    let db: Firestore!
    
    private init() {
        self.db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    // Retrieve all themas
    func getAllThemas(callback: @escaping ([Thema]) -> Void) {
        var themas = [Thema]()
        db.collection("thema").getDocuments() {
            querySnapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                themas = querySnapshot!.documents.compactMap({Thema(dictionary: $0.data())})
                callback(themas)
            }
        }
    }
}
