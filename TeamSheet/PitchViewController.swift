//
//  PitchViewController.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 07/04/2019.
//  Copyright © 2019 Jake Renshaw. All rights reserved.
//

import UIKit
import SnapKit

enum PlayerType {
    case squad
    case opposition
}

class PitchViewController: UIViewController, PlayerIconDelegate {
    
    var squad = [Player]()
    var opposition = [Player]()
    var playerIcons = [PlayerIcon]()
    var oppositionIcons = [PlayerIcon]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+ Opposition", style: .plain, target: self, action: #selector(addOpposition))
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
        let playerIcon = PlayerIcon(frame: CGRect(x: player.x, y: player.y, width: 10, height: 10), name: player.name, number: player.number, captain: player.captain)
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
        self.view.bringSubviewToFront(viewDrag)
        let translation = sender.translation(in: self.view)
        viewDrag.center = CGPoint(x: viewDrag.center.x + translation.x, y: viewDrag.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    func updatePlayerPositon(view: PlayerIcon, x: CGFloat, y: CGFloat) {
        squad.forEach { (playerIcon) in
            if playerIcon.name == view.name && playerIcon.number == view.number {
                playerIcon.x = x
                playerIcon.y = y
            }
        }
    }
    
    @objc func addOpposition() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "- Opposition", style: .plain, target: self, action: #selector(removeOpposition))
        var i = 1
        while i < 12 {
            let player = Player(name: "-", number: "\(i)", captain: false, x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            opposition.append(player)
            addPlayer(player: player, playerType: .opposition)
            i += 1
        }
    }
    
    @objc func removeOpposition() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+ Opposition", style: .plain, target: self, action: #selector(addOpposition))
        opposition.removeAll()
        oppositionIcons.forEach { (oppositonIcon) in
            oppositonIcon.removeFromSuperview()
        }
        oppositionIcons.removeAll()
    }

}
