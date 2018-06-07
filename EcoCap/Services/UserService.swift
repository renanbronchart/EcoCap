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
    var challenges = [Challenge]()
    
    private init() {
        self.db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    /*
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
    */
    
    // Update the userDetail passed in params
    func updateUserDetail(userDetail: UserDetail, callback: @escaping (String, UserDetail, Bool) -> Void) {
        var currentUserDetail: String = ""
        db.collection("user_detail").whereField("user_id", isEqualTo: userDetail.user_id).getDocuments() {
            querySnapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                currentUserDetail = querySnapshot!.documents.first!.documentID
                if userDetail.level > querySnapshot?.documents.first?.get("level") as! Int {
                    ChallengeService.instance.getAllChallenges(level: userDetail.level, callback: { (challengesArray) in
                        self.challenges = challengesArray
                        var challengeIds = [String]()
                        for challenge in self.challenges {
                            challengeIds.append(challenge.uid)
                            self.db.collection("challenge_run").addDocument(data: ["name": challenge.name,"level": challenge.level,"description": challenge.description,"points": challenge.points, "short_description": challenge.short_description,"repetition": challenge.repetition, "repetition_completed": 0,"repetition_type": challenge.repetition_type, "repetition_name": challenge.repetition_name,"type": challenge.type,"user_id": (Auth.auth().currentUser?.uid)!,"completed": false,"challenge_id": challenge.uid])
                            challengeIds.append(contentsOf: userDetail.challenges_ids)
                        }
                        self.db.collection("user_detail").document((Auth.auth().currentUser?.uid)!).setData(["name": userDetail.name, "score": userDetail.score, "level": userDetail.level, "challenges_ids": challengeIds, "user_id": (Auth.auth().currentUser?.uid)!])
                    })
                } else {
                    callback(currentUserDetail, userDetail, false)
                }
            }
        }
    }
    
    // Callback of the updateUserDetail method
    func updateUserDetailAction(userDetailId: String, userDetail: UserDetail, hasLevelUp: Bool) {
        
        self.db.collection("user_detail").document(userDetailId).setData(userDetail.dictionary)
    }
    
    // Get UserDetail By user logged in id
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
    
    // Get current Ranking
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
    
    /*
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
    */
}
