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
            
            var challenges = [Challenge]()
            
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                challenges += querySnapshot?.documents.compactMap({ Challenge(dictionary: $0.data())}) ?? [Challenge]()
            }
            
            callback(challenges)
        }
    }
    
    // Retrieve challenge completed by User
    func getCompletedChallengesByUser(userId: String, callback: @escaping ([Challenge]) -> Void) {
        db.collection("challenge_run").whereField("completed", isEqualTo: true).whereField("user_id", isEqualTo: userId).getDocuments { (querySnapshot, error) in
            var completedChallenges = [Challenge]()
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                for challenge_run in querySnapshot!.documents.compactMap({ ChallengeRun(dictionary: $0.data()) }) {
                    self.db.collection("challenge").document(challenge_run.challenge_id).getDocument(completion: { (documentSnapshot, error) in
                        if let error = error {
                            print("\(error.localizedDescription)")
                        } else {
                            completedChallenges.append(Challenge(dictionary: (documentSnapshot?.data())!)!)
                        }
                    })
                    
                }
            }
            callback(completedChallenges)
        }
    }
    
    // Retrieve challenge run by user_id and challenge_id
    func getChallengeRunByUserAndChallenge(userId: String, challengeId: String, callback: @escaping (ChallengeRun) -> Void) {
        db.collection("challenge_run").whereField("user_id", isEqualTo: userId).whereField("challenge_id", isEqualTo: challengeId).getDocuments { (querySnapshot, error) in
            var challengeRun: ChallengeRun?
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                for result in querySnapshot!.documents {
                    challengeRun = ChallengeRun(dictionary: result.data())
                }
            }
            callback(challengeRun!)
        }
    }
    
    // Retrieve filtered challenge by type
    func getChallengesByType(type: String, callback: @escaping ([Challenge]) -> Void) {
        db.collection("challenge").whereField("type", isEqualTo: type).getDocuments { (querySnapshot, error) in
            var challengeFilteredByType = [Challenge]()
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                challengeFilteredByType = querySnapshot!.documents.compactMap({ Challenge(dictionary: $0.data()) })
            }
            callback(challengeFilteredByType)
        }
    }
}

