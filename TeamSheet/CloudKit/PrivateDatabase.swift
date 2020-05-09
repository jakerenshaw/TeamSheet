//
//  PrivateDatabase.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 26/04/2020.
//  Copyright © 2020 Jake Renshaw. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

protocol PrivateDatabaseDelegate: class {
    func presentSquadLoaderAlert(squadNames: [String], completion: @escaping ((String?)->Void))
    func fetchedPlayers(players: [Player])
    func presentSquadNameAlert(completion: @escaping ((String?) -> Void))
    func presentCloudSignInError()
    func presentRecordExistsError()
    func presentSuccessAlert(squadName: String)
}

class PrivateDatabase: NSObject {
    let privateDataBase = CKContainer.default().privateCloudDatabase
    weak var delegate: PrivateDatabaseDelegate?
    
    func loadSquad() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Squad", predicate: predicate)
        self.privateDataBase.perform(
            query,
            inZoneWith: CKRecordZone.default().zoneID) { [weak self] results, error in
                guard let self = self else { return }
                    if let error = error {
                        self.handleError(errorDescription: error.localizedDescription)
                        return
                    }
                guard let results = results else { return }
                var squadNames = [String]()
                results.forEach { (record) in
                    if let squadName = record["squadName"] as? String {
                        squadNames.append(squadName)
                    }
                }
                self.delegate?.presentSquadLoaderAlert(squadNames: squadNames) { (chosenSquad) in
                    let squad = results.first { (record) -> Bool in
                        record["squadName"] as? String == chosenSquad
                    }
                    if let players = squad?["players"] as? [CKRecord.Reference] {
                        self.fetchPlayers(references: players)
                    }
                }
        }
    }
    
    func fetchPlayers(references: [CKRecord.Reference]) {
        let recordIDs = references.map { $0.recordID }
        let operation = CKFetchRecordsOperation(recordIDs: recordIDs)
        operation.qualityOfService = .utility
        operation.fetchRecordsCompletionBlock = { records, error in
            if let error = error {
                self.handleError(errorDescription: error.localizedDescription)
                return
            }
            if let records = records {
                var newPlayers = [Player]()
                records.forEach { (_, record) in
                    if let player = self.createPlayer(record: record) {
                        newPlayers.append(player)
                    }
                }
                self.delegate?.fetchedPlayers(players: newPlayers)
            }
        }
        self.privateDataBase.add(operation)
    }
    
    func saveSquad(squad: [Player]) {
        self.delegate?.presentSquadNameAlert { (squadName) in
            guard let squadName = squadName else {
                return
            }
            let id = CKRecord.ID(recordName: squadName)
            let squadToSave = CKRecord(recordType: "Squad", recordID: id)
            squadToSave["squadName"] = squadName
            let squadReference = CKRecord.Reference(record: squadToSave, action: .deleteSelf)
            var players = [CKRecord.Reference]()
            squad.forEach { (player) in
                let playerToSave = CKRecord(recordType: "Player")
                playerToSave["name"] = player.name
                playerToSave["number"] = player.number
                playerToSave["captain"] = Int(truncating: NSNumber(value:player.captain))
                playerToSave["x"] = Double(player.x)
                playerToSave["y"] = Double(player.y)
                playerToSave["teamColor"] = player.teamColor.toHexString()
                playerToSave["squad"] = squadReference
                let playerReference = CKRecord.Reference(record: playerToSave, action: .deleteSelf)
                players.append(playerReference)
                self.uploadPlayer(record: playerToSave)
            }
            squadToSave["players"] = players
            self.uploadSquad(record: squadToSave)
        }
    }
    
    func createPlayer(record: CKRecord) -> Player? {
        guard let name = record["name"] as? String,
            let number = record["number"] as? String,
            let captain = record["captain"] as? Bool,
            let x = record["x"] as? CGFloat,
            let y = record["y"] as? CGFloat,
            let teamColor = record["teamColor"] as? String else {
            return nil
        }
        return Player(
            name: name,
            number: number,
            captain: captain,
            x: x,
            y: y,
            teamColor: UIColor(hexString: teamColor)
        )
    }
    
    func uploadSquad(record: CKRecord) {
        self.privateDataBase.save(record) { (record, error) in
            if let error = error {
                self.handleError(errorDescription: error.localizedDescription)
                return
            }
            if let record = record,
                let squadName = record["squadName"] as? String {
                self.delegate?.presentSuccessAlert(squadName: squadName)
            }
        }
    }
    
    func uploadPlayer(record: CKRecord) {
        self.privateDataBase.save(record) { (record, error) in
            if let error = error {
                self.handleError(errorDescription: error.localizedDescription)
                return
            }
        }
    }
    
    func handleError(errorDescription: String) {
        var finalDescription = errorDescription
        finalDescription = formatIfRecordExists(errorDescription: errorDescription)
        switch CloudKitError(rawValue: finalDescription) {
        case .none:
            print(">>> error not handled \(finalDescription)")
            // display generic error
        case .some(let error):
            switch error {
            case .authenticateAccount:
                self.delegate?.presentCloudSignInError()
            case .recordExists:
                self.delegate?.presentRecordExistsError()
            }
        }
    }
    
    func formatIfRecordExists(errorDescription: String) -> String {
        let recordExists = "record to insert already exists"
        return errorDescription.contains(recordExists) ? recordExists : errorDescription
    }
}
