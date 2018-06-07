//
//  UserService.swift
//  EcoCap
//
//  Created by Bourgoin Théo on 07/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserService {
    
    let MAX_LEVEL: Int = 3
    
    var db: Firestore
    static let instance = UserService()
    
    private init() {
        self.db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    // Increment the level of the user passed in params
    func levelUpUser(userId: String, callback: @escaping (DocumentReference, Int) -> Void) {
        let userDetail = db.collection("user_detail").document(userId)
        db.collection("user_detail").document(userId).getDocument() {
            querySnapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                let userLevel: Int! = querySnapshot!.get("level") as! Int
                if userLevel < self.MAX_LEVEL {
                    callback(userDetail, userLevel)
                }
            }
        }
    }
    
    func getUserDetail(callback: @escaping (UserDetail) -> Void) {
        var userDetail: UserDetail!
        db.collection("user_detail").document((Auth.auth().currentUser?.uid)!).getDocument() {
            querySnapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                userDetail = querySnapshot.flatMap({UserDetail(dictionary: $0.data()!)})
                callback(userDetail)
            }
        }
    }
    
    func getUserDetailsOrderedByScore(callback: @escaping ([UserDetail]) -> Void) {
        var userDetails = [UserDetail]()
        db.collection("user_detail").order(by: "score", descending: true).getDocuments() {
            querySnapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                userDetails = querySnapshot!.documents.compactMap({UserDetail(dictionary: $0.data())})
                callback(userDetails)
            }
        }
    }
    
    // Execute the levelUp action of levelUpUser
    func levelUpUserAction(userDetail: DocumentReference, userLevel: Int) {
        userDetail.updateData(["level": userLevel + 1])
    }
    
    // Increment user score
    func incrementUserScore(points: Int, userId: String) {
        let userDetail = db.collection("user_detail").document(userId)
        db.collection("user_detail").document(userId).getDocument() {
            querySnapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                let userScore: Int! = querySnapshot!.get("score") as! Int
                userDetail.updateData(["score": userScore + points])
            }
        }
    }
    
}
