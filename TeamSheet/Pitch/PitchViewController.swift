//
//  PitchViewController.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 08/05/2020.
//  Copyright © 2020 Jake Renshaw. All rights reserved.
//

import UIKit

enum SquadError: String {
    case missingInfo
    case multipleCaptains
    case duplicatePlayers
}

protocol PitchViewControllerDelegate: class {
    func error(error: SquadError)
}

class PitchViewController: UIViewController, PlayerIconDelegate {
    
    @IBOutlet weak var pitchImageView: UIImageView!
    
    var opposition = [Player]()
    var playerIcons = [PlayerIcon]()
    var oppositionIcons = [PlayerIcon]()
    let squadStore: SquadStore
    weak var delegate: PitchViewControllerDelegate?
    
    init(squadStore: SquadStore, nibName: String?, bundle: Bundle?) {
        self.squadStore = squadStore
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !errorOccured() {
            sortSquad()
        }
        super.viewDidAppear(animated)
    }
        
    func duplicatePlayer() -> Bool {
        var duplicatePlayer = false
        var duplicates = [Player]()
        self.squadStore.squad.forEach { (player) in
            if !duplicates.contains(player) {
                duplicates.append(player)
            } else {
                duplicatePlayer = true
                return
            }
        }
        return duplicatePlayer
    }
    
    func multipleCaptains() -> Bool {
        var numberOfCaptains = 0
        self.squadStore.squad.forEach { (player) in
            if player.captain {
                numberOfCaptains += 1
            }
        }
        return numberOfCaptains > 1
    }
    
    func missingInfo() -> Bool {
        var missing = false
        self.squadStore.squad.forEach { (player) in
            if player.name == "" || player.number == "" {
                missing = true
                return
            }
        }
        return missing
    }
    
    func errorOccured() -> Bool {
        var error = false
        if missingInfo() {
            self.delegate?.error(error: .missingInfo)
            error = true
        } else if multipleCaptains() {
            self.delegate?.error(error: .multipleCaptains)
            error = true
        } else if duplicatePlayer() {
            self.delegate?.error(error: .duplicatePlayers)
            error = true
        }
        return error
    }
    
    func sortSquad() {
        if self.squadStore.squad.isEmpty {
            self.removeSquad()
        } else if playerIcons.isEmpty {
            self.addSquad()
        } else {
            addPlayerCheck()
            removePlayerCheck()
        }
    }
    
    func addPlayerCheck() {
        self.squadStore.squad.forEach { (player) in
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
            self.squadStore.squad.forEach { (player) in
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
        self.squadStore.squad.forEach { (player) in
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
        self.squadStore.squad.forEach { (playerIcon) in
            if playerIcon.name == view.name && playerIcon.number == view.number {
                playerIcon.x = x
                playerIcon.y = y
            }
        }
    }
    
    func updatePlayerTeamColor(view: PlayerIcon, color: UIColor) {
        self.squadStore.squad.forEach { (playerIcon) in
            if playerIcon.name == view.name && playerIcon.number == view.number {
                playerIcon.teamColor = color
            }
        }
    }
    
    @objc func addOpposition() {
        removeOpposition()
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
    
    func toggleOppostion() {
        if opposition.isEmpty {
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
}
