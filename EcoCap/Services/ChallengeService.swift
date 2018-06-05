//
//  ChallengeService.swift
//  EcoCap
//
//  Created by Bourgoin Théo on 04/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import Foundation
import FirebaseFirestore

class ChallengeService {
    
    var db:Firestore!
    var challengeArray = [Challenge]()
    var completedChallenges = [Challenge]()
    static let instance = ChallengeService()
    
    private init() {
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    // Retrieve challenges
    // ChallengeService.instance.getChallenges { (challenges) in
    // print(challenges.first!.name)
    func getChallenges(callback: @escaping ([Challenge]) -> Void) {
        db.collection("challenge").getDocuments {(querySnapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                self.challengeArray = querySnapshot!.documents.compactMap({ Challenge(dictionary: $0.data())})
            }
            callback(self.challengeArray)
        }
    }
    
    func getCompletedChallengesByUser(userId: String, callback: @escaping ([Challenge]) -> Void) {
        db.collection("challenge_run").whereField("completed", isEqualTo: true).whereField("user_id", isEqualTo: userId).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                for challenge_run in querySnapshot!.documents.compactMap({ ChallengeRun(dictionary: $0.data()) }) {
                    self.completedChallenges.append(self.db.collection("challenge").document(challenge_run.challenge_id).compactMap({Challenge(dictionary: $0.data())}))
                }
            }
            callback(self.completedChallenges)
        }
    }
}

