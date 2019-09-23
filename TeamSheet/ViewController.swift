//
//  ViewController.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 07/04/2019.
//  Copyright © 2019 Jake Renshaw. All rights reserved.
//

import UIKit

class Player: Equatable, Encodable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.name == rhs.name && lhs.number == rhs.number
    }
    
    var name: String
    var number: String
    var captain: Bool
    var x: CGFloat
    var y: CGFloat
    
    init(name: String, number: String, captain: Bool, x: CGFloat, y: CGFloat) {
        self.name = name
        self.number = number
        self.captain = captain
        self.x = x
        self.y = y
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TeamMateTableViewCellDelegate {
    
    @IBOutlet weak var playersTableView: PlayersTableView!
    
    var players = [TeamMateTableViewCell]()
    var activeCell: TeamMateTableViewCell?
    var vc: PitchViewController?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playersTableView.dequeueReusableCell(withIdentifier: "Cell") as? TeamMateTableViewCell
        cell?.delegate = self
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.playersTableView.beginUpdates()
            self.players.remove(at: indexPath.row)
            self.playersTableView.deleteRows(at: [indexPath], with: .automatic)
            self.playersTableView.endUpdates()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.playersTableView.estimatedRowHeight = 0
        self.playersTableView.estimatedSectionHeaderHeight = 0
        self.playersTableView.estimatedSectionFooterHeight = 0
        self.playersTableView.tableFooterView = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        navigationItem.title = "Squad"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPlayer))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pitch", style: .plain, target: self, action: #selector(showPitch))
        playersTableView.register(UINib(nibName: "TeamMateTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.playersTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            if let activeCell = self.activeCell, let indexPath = self.playersTableView.indexPath(for: activeCell) {
                self.playersTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            self.playersTableView.scrollIndicatorInsets = self.playersTableView.contentInset
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.playersTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @objc func addPlayer() {
        let cell = playersTableView.dequeueReusableCell(withIdentifier: "Cell") as? TeamMateTableViewCell
        players.append(cell!)
        playersTableView.beginUpdates()
        playersTableView.insertRows(at: [IndexPath(row: players.count-1, section: 0)], with: .automatic)
        playersTableView.endUpdates()
    }
    
    @objc func showPitch() {
        if duplicatePlayer() {
            showAlert(message: "Duplicate players in squad")
        } else {
            var squad = [Player]()
            var emptyField = false
            playersTableView.visibleCells.forEach { (cell) in
                guard let cell = cell as? TeamMateTableViewCell, let name = cell.nameTextField.text, name != "", let number = cell.numberTextField.text, number != "" else {
                    showAlert(message: "A name/number is missing for one of the players")
                    emptyField = true
                    return
                }
                let player = Player(name: name, number: number, captain: cell.captain, x: self.view.bounds.width / 2, y: (self.view.bounds.height / 2) + 60)
                squad.append(player)
            }
            if !emptyField {
                if vc == nil {
                    vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PitchViewController") as? PitchViewController
                } else {
                    vc?.squad = squad
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
            }
        }
    }
    
    func duplicatePlayer() -> Bool {
        var duplicatePlayer = false
        var duplicates = [TeamMateTableViewCell]()
        playersTableView.visibleCells.forEach { (cell) in
            guard let cell = cell as? TeamMateTableViewCell else {
                return
            }
            if !duplicates.contains(cell) {
                duplicates.append(cell)
            } else {
                duplicatePlayer = true
                return
            }
        }
        return duplicatePlayer
    }
    
    func showAlert(message: String) {

        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func setActiveCell(cell: TeamMateTableViewCell) {
        self.activeCell = cell
    }
    
    func setCaptain(cell: TeamMateTableViewCell) {
        playersTableView.visibleCells.forEach { (playerCell) in
            guard let playerCell = playerCell as? TeamMateTableViewCell else {
                return
            }
            if playerCell != cell {
                playerCell.captain = false
                playerCell.captainButton.backgroundColor = UIColor.white
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}

