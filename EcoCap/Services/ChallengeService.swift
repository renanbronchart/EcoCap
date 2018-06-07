//
//  ChallengeService.swift
//  EcoCap
//
//  Created by Bourgoin Théo on 06/06/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import Foundation
import FirebaseFirestore

class ChallengeService {
    
    var db: Firestore
    static let instance = ChallengeService()
    
    private init() {
        self.db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    // Retrieve all challenges by level
    func getAllChallenges(level: Int, callback: @escaping ([Challenge]) -> Void) {
        var challenges = [Challenge]()
        self.db.collection("challenge").whereField("level", isEqualTo: level).getDocuments() {
            querySnapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                challenges = querySnapshot!.documents.compactMap({Challenge(dictionary: $0.data())})
                callback(challenges)
            }
        }
    }
    
    // Retrieve challenge runs by user
    func getAllChallengeRuns(userId: String, completed: Bool, callback: @escaping ([ChallengeRun]) -> Void) {
        var challengeRuns = [ChallengeRun]()
        self.db.collection("challenge_run").whereField("user_id", isEqualTo: userId).whereField("completed", isEqualTo: completed).getDocuments() {
            querySnapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                challengeRuns = querySnapshot!.documents.compactMap({ChallengeRun(dictionary: $0.data())})
                callback(challengeRuns)
            }
        }
    }
    
    func updateChallengeRun(challengeRun: ChallengeRun, callback: @escaping (String, ChallengeRun) -> Void) {
        var currentChallengeRun: String = ""
        db.collection("challenge_run").whereField("user_id", isEqualTo: challengeRun.user_id).whereField("challenge_id", isEqualTo: challengeRun.challenge_id).getDocuments() {
            querySnapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                currentChallengeRun = querySnapshot!.documents.first!.documentID
                callback(currentChallengeRun, challengeRun)
            }
        }
    }
    
    func updateChallengeRunAction(challengeRunId: String, challengeRun: ChallengeRun)
    {
        self.db.collection("challenge_run").document(challengeRunId).setData(challengeRun.dictionary)
    }
    
    /*
    // Increment repetition completed on current challenge run
    // ChallengeService.instance.addRepetitionChallengeRun(userId: "ZDzTjDooIfVRvtDWpLnkDcsU7wj1", challenge_id: "CYTvtaqvD0fwJOR8b5nF", callback: { (challengeRun, querySnapshot) in ChallengeService.instance.addRepetitionAction(challengeRun: challengeRun, querySnapshot: querySnapshot)
    // })
    func addRepetitionChallengeRun(userId: String, challenge_id: String, callback: @escaping ([ChallengeRun], QuerySnapshot) -> Void) {
        var challengeRun = [ChallengeRun]()
        self.db.collection("challenge_run").whereField("challenge_id", isEqualTo: challenge_id).whereField("user_id", isEqualTo: userId).getDocuments() {
            querySnapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                challengeRun = querySnapshot!.documents.compactMap({ChallengeRun(dictionary: $0.data())})
                print(challengeRun)
                callback(challengeRun, querySnapshot!)
            }
        }
    }
    
    // Callback function of AddRepetitionChallengeRun
    func addRepetitionAction(challengeRun: [ChallengeRun], querySnapshot: QuerySnapshot) {
        print(challengeRun, querySnapshot)
        // Add the current completed_repetition + 1
        // If the repetition value of the challenge is equal to the challenge run repetition completed + 1, set completed to true
        if (challengeRun.first!.repetition == challengeRun.first!.repetition_completed + 1) {
            self.db.collection("challenge_run").document(querySnapshot.documents.first!.documentID).updateData(["repetition_completed": 1, "completed": true])
        } else {
            self.db.collection("challenge_run").document(querySnapshot.documents.first!.documentID).updateData(["repetition_completed": 1])
        }
    }
    */
}
