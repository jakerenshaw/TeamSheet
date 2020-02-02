//
//  ViewController.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 07/04/2019.
//  Copyright © 2019 Jake Renshaw. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TeamMateTableViewCellDelegate {
    
    @IBOutlet weak var playersTableView: PlayersTableView!
    
    var players = [Player]()
    var activeCell: TeamMateTableViewCell?
    var vc: PitchViewController?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playersTableView.dequeueReusableCell(withIdentifier: "TeamMateTableViewCell") as? TeamMateTableViewCell
        cell?.captain = players[indexPath.row].captain
        cell?.nameTextField.text = players[indexPath.row].name
        cell?.numberTextField.text = players[indexPath.row].number
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        navigationItem.title = "Squad"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPlayer))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pitch", style: .plain, target: self, action: #selector(showPitch))
        playersTableView.register(UINib(nibName: "TeamMateTableViewCell", bundle: nil), forCellReuseIdentifier: "TeamMateTableViewCell")
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
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.playersTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    @objc func addPlayer() {
        let player = Player()
        players.append(player)
        playersTableView.beginUpdates()
        playersTableView.insertRows(at: [IndexPath(row: players.count-1, section: 0)], with: .automatic)
        playersTableView.endUpdates()
    }
    
    @objc func showPitch() {
        if duplicatePlayer() {
            showAlert(message: "Duplicate players in squad")
        } else {
            if vc == nil {
                vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PitchViewController") as? PitchViewController
            } else {
                vc?.squad = players
                self.navigationController?.pushViewController(vc!, animated: true)
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
            } else {
                playerCell.captain.toggle()
            }
            self.updatePlayerInfo(cell: playerCell)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func updatePlayerInfo(cell: TeamMateTableViewCell) {
        guard let indexPath = playersTableView.indexPath(for: cell),
            let name = cell.nameTextField.text,
            name != "",
            let number = cell.numberTextField.text,
            number != "" else {
            return
        }
        players[indexPath.row] = Player(name: name, number: number, captain: cell.captain, x: self.view.bounds.width / 2, y: (self.view.bounds.height / 2) + 60)
    }
}

