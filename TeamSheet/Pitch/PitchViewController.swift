//
//  PitchViewController.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 07/04/2019.
//  Copyright © 2019 Jake Renshaw. All rights reserved.
//

import UIKit
import SnapKit
import CloudKit

class PitchViewController:
    UIViewController,
    PlayerIconDelegate,
    PitchMenuViewDelegate
{
    
    @IBOutlet weak var pitchImageView: UIImageView!
    
    var squad = [Player]()
    var opposition = [Player]()
    var playerIcons = [PlayerIcon]()
    var oppositionIcons = [PlayerIcon]()
    var pitchMenuView: PitchMenuView?
    let publicDataBase = CKContainer.default().publicCloudDatabase
    let privateDataBase = CKContainer.default().privateCloudDatabase
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let menuImage: UIImage?
        let menuButton: UIBarButtonItem?
        if #available(iOS 13.0, *) {
            menuImage = UIImage(named: "menu")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            menuButton = UIBarButtonItem(image: menuImage, style: .plain, target: self, action: #selector(toggleMenu))
        } else {
            menuImage = UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate)
            menuButton = UIBarButtonItem(image: menuImage, style: .plain, target: self, action: #selector(toggleMenu))
            menuButton?.tintColor = .gray
        }
        self.navigationItem.rightBarButtonItem = menuButton
    }
    
    @objc func toggleMenu() {
        if let menu = self.pitchMenuView {
            menu.removeFromSuperview()
            self.pitchMenuView = nil
        } else {
            let menuWidth: CGFloat = 200
            let menuHeight: CGFloat = 80
            let pitchFrame = self.pitchImageView.frame
            pitchMenuView = PitchMenuView(
                frame: CGRect(
                    x: pitchFrame.width - menuWidth,
                    y: pitchFrame.origin.y,
                    width: menuWidth,
                    height: menuHeight
                )
            )
            pitchMenuView?.delegate = self
            self.view.addSubview(pitchMenuView!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sortSquad()
    }
    
    func sortSquad() {
        if squad.isEmpty {
            self.removeSquad()
        } else if playerIcons.isEmpty {
            self.addSquad()
        } else {
            addPlayerCheck()
            removePlayerCheck()
        }
    }
    
    func addPlayerCheck() {
        squad.forEach { (player) in
            var playerInSquad = false
            playerIcons.forEach { (playerIcon) in
                if (playerIcon.name == player.name) && (playerIcon.number == player.number) {
                    if player.captain {
                        playerIcon.setCaptain()
                    } else {
                        playerIcon.removeCaptain()
                    }
                    playerInSquad = true
                }
            }
            if !playerInSquad {
                addPlayer(player: player, playerType: .squad)
            }
        }
    }
    
    func removePlayerCheck() {
        playerIcons.forEach { (playerIcon) in
            var playerInSquad = false
            squad.forEach { (player) in
                if (playerIcon.name == player.name) && (playerIcon.number == player.number) {
                    playerInSquad = true
                }
            }
            if !playerInSquad {
                removePlayer(player: playerIcon)
            }
        }
    }
    
    func addPlayer(player: Player, playerType: PlayerType) {
        let playerIcon = PlayerIcon(frame: CGRect(x: player.x, y: player.y, width: 10, height: 10), name: player.name, number: player.number, captain: player.captain, teamColor: player.teamColor)
        playerIcon.delegate = self
        self.view.addSubview(playerIcon)
        switch playerType {
        case .squad:
            playerIcons.append(playerIcon)
        case .opposition:
            oppositionIcons.append(playerIcon)
        }
    }
    
    func removePlayer(player: PlayerIcon) {
        player.removeFromSuperview()
        playerIcons.removeAll { (playerIcon) -> Bool in
            return player.name == playerIcon.name && player.number == playerIcon.number
        }
    }
    
    func removeSquad() {
        playerIcons.forEach { (playerIcon) in
            playerIcon.removeFromSuperview()
        }
        playerIcons.removeAll()
    }
    
    func addSquad() {
        squad.forEach { (player) in
            addPlayer(player: player, playerType: .squad)
        }
    }
    
    func draggedView(_ sender:UIPanGestureRecognizer, viewDrag: PlayerIcon) {
        guard let senderView = sender.view else {
            return
        }
        
        var translation = sender.translation(in: view)
        
        translation.x = max(translation.x, pitchImageView.frame.minX - viewDrag.frame.minX)
        translation.x = min(translation.x, pitchImageView.frame.maxX - viewDrag.frame.maxX)
        
        translation.y = max(translation.y, pitchImageView.frame.minY - viewDrag.frame.minY)
        translation.y = min(translation.y, pitchImageView.frame.maxY - viewDrag.frame.maxY)
        
        senderView.center = CGPoint(x: senderView.center.x + translation.x, y: senderView.center.y + translation.y)
        sender.setTranslation(.zero, in: view)
        view.bringSubviewToFront(senderView)
    }
    
    func updatePlayerPositon(view: PlayerIcon, x: CGFloat, y: CGFloat) {
        squad.forEach { (playerIcon) in
            if playerIcon.name == view.name && playerIcon.number == view.number {
                playerIcon.x = x
                playerIcon.y = y
            }
        }
    }
    
    func updatePlayerTeamColor(view: PlayerIcon, color: UIColor) {
        squad.forEach { (playerIcon) in
            if playerIcon.name == view.name && playerIcon.number == view.number {
                playerIcon.teamColor = color
            }
        }
    }
    
    @objc func addOpposition() {
        var i = 1
        while i < 12 {
            let player = Player(name: "-", number: "\(i)", captain: false, x: self.view.bounds.width / 2, y: self.view.bounds.height / 2, teamColor: .white)
            opposition.append(player)
            addPlayer(player: player, playerType: .opposition)
            i += 1
        }
    }
    
    @objc func removeOpposition() {
        opposition.removeAll()
        oppositionIcons.forEach { (oppositonIcon) in
            oppositonIcon.removeFromSuperview()
        }
        oppositionIcons.removeAll()
    }
    
    func toggleOppostion(add: Bool) {
        if add {
            self.addOpposition()
        } else {
            self.removeOpposition()
        }
    }
    
    func toggleTitle(add: Bool) {
        if add {
            let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            textField.addDoneToolbar()
            textField.text = "Insert title..."
            textField.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            textField.textAlignment = .center
            self.navigationItem.titleView = textField
        } else {
            self.navigationItem.titleView = nil
        }
    }
    
    func loadSquad() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Squad", predicate: predicate)
        self.publicDataBase.perform(
            query,
            inZoneWith: CKRecordZone.default().zoneID) { [weak self] results, error in
                guard let self = self else { return }
                    if let error = error {
                        DispatchQueue.main.async {
                            print(">>> \(error)")
                        }
                        return
                    }
                guard let results = results else { return }
                var squadNames = [String]()
                results.forEach { (record) in
                    if let squadName = record["squadName"] as? String {
                        squadNames.append(squadName)
                    }
                }
                self.presentSquadLoaderAlert(squadNames: squadNames) { (chosenSquad) in
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
                print(">>> \(error)")
            }
            if let records = records {
                var newPlayers = [Player]()
                records.forEach { (_, record) in
                    if let player = Player(record: record) {
                        newPlayers.append(player)
                    }
                }
                DispatchQueue.main.async {
                    self.removeSquad()
                    self.squad = newPlayers
                    self.sortSquad()
                }
            }
        }
        self.privateDataBase.add(operation)
    }
    
    func saveSquad() {
        self.presentSquadNameAlert { (squadName) in
            guard let squadName = squadName else {
                return
            }
            let squadToSave = CKRecord(recordType: "Squad")
            squadToSave["squadName"] = squadName
            let squadReference = CKRecord.Reference(record: squadToSave, action: .deleteSelf)
            var players = [CKRecord.Reference]()
            self.squad.forEach { (player) in
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
    
    func uploadSquad(record: CKRecord) {
        self.publicDataBase.save(record) { (record, error) in
            if let error = error {
                print(">>> squad error = \(error)")
            }
            if let record = record {
                print(">>> squad complete = \(record)")
            }
        }
    }
    
    func uploadPlayer(record: CKRecord) {
        self.privateDataBase.save(record) { (record, error) in
            if let error = error {
                print(">>> player error = \(error)")
            }
            if let record = record {
                print(">>> player complete = \(record)")
            }
        }
    }
    
    func presentSquadNameAlert(completion: @escaping ((String?) -> Void)) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Squad Name", message: "Please enter the Squad Name", preferredStyle: .alert)
            alert.addTextField {(_) in }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
                completion(nil)
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancelAction)
            let doneAction = UIAlertAction(title: "Save", style: .default) { (_) in
                var name: String?
                if let textField = alert.textFields?.first,
                    let squadName = textField.text {
                    name = squadName
                }
                completion(name)
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(doneAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func presentSquadLoaderAlert(squadNames: [String], completion: @escaping ((String?)->Void)) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Select Squad", message: "Please select a squad to load", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
                completion(nil)
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancelAction)
            squadNames.forEach { (squadName) in
                let alertAction = UIAlertAction(title: squadName, style: .default) { (_) in
                    completion(squadName)
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(alertAction)
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
}
