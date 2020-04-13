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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(toggleMenu))
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(toggleMenu))
        var i = 1
        while i < 12 {
            let player = Player(name: "-", number: "\(i)", captain: false, x: self.view.bounds.width / 2, y: self.view.bounds.height / 2, teamColor: .white)
            opposition.append(player)
            addPlayer(player: player, playerType: .opposition)
            i += 1
        }
    }
    
    @objc func removeOpposition() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(toggleMenu))
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

}
