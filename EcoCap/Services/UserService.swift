//
//  UserService.swift
//  EcoCap
//
//  Created by Bourgoin Théo on 05/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import Foundation
import FirebaseFirestore

class UserService {
    
    var db:Firestore!
    var userDetail: UserDetail?

    static let instance = UserService()
    
    private init() {
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    // Get the details of a specified user
    func getUserDetail(user_id: String, callback: @escaping (UserDetail) -> Void) {
        db.collection("user_detail").whereField("user_id", isEqualTo: user_id).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                self.userDetail = querySnapshot?.documents.first.flatMap({UserDetail(dictionary: $0.data())})
            }
            callback(self.userDetail!)
        }
    }
    
}


