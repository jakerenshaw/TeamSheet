//
//  SquadViewController.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 08/05/2020.
//  Copyright © 2020 Jake Renshaw. All rights reserved.
//

import UIKit

class SquadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SquadTableViewCellDelegate {
    
    @IBOutlet weak var squadTableView: UITableView!

    var players = [Player]()
    var activeCell: SquadTableViewCell?
    var vc: OldPitchViewController?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = squadTableView.dequeueReusableCell(withIdentifier: "SquadTableViewCell") as? SquadTableViewCell
        cell?.captain = players[indexPath.row].captain
        cell?.nameTextField.text = players[indexPath.row].name
        cell?.numberTextField.text = players[indexPath.row].number
        cell?.delegate = self
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.squadTableView.beginUpdates()
            self.players.remove(at: indexPath.row)
            self.squadTableView.deleteRows(at: [indexPath], with: .automatic)
            self.squadTableView.endUpdates()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.squadTableView.delegate = self
        self.addTapGesture()
        
        let titleLabel = UILabel()
        titleLabel.text = "Squad"
        navigationItem.titleView = titleLabel
        
        let backButton = UIBarButtonItem(title: "Squad", style: .plain, target: self, action: nil)
        backButton.tintColor = .systemGray
        navigationItem.backBarButtonItem = backButton
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPlayer))
        addButton.tintColor = .systemGray
        navigationItem.leftBarButtonItem = addButton
        
        let pitchButton = UIBarButtonItem(title: "Pitch", style: .plain, target: self, action: #selector(showPitch))
        pitchButton.tintColor = .systemGray
        navigationItem.rightBarButtonItem = pitchButton
        
        squadTableView.register(UINib(nibName: "SquadTableViewCell", bundle: nil), forCellReuseIdentifier: "SquadTableViewCell")
    }
    
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.squadTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            if let activeCell = self.activeCell, let indexPath = self.squadTableView.indexPath(for: activeCell) {
                self.squadTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            self.squadTableView.scrollIndicatorInsets = self.squadTableView.contentInset
        }
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.squadTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    @objc func addPlayer() {
        let player = Player(
            x: self.view.bounds.width / 2,
            y: (self.view.bounds.height / 2) + 60
        )
        players.append(player)
        squadTableView.beginUpdates()
        squadTableView.insertRows(at: [IndexPath(row: players.count-1, section: 0)], with: .automatic)
        squadTableView.endUpdates()
    }
    
    @objc func showPitch() {
        if missingInfo() {
            DispatchQueue.main.async {
                self.showAlert(message: "Info for a player is missing")
            }
        } else if multipleCaptains() {
            showAlert(message: "More than one captain is selected")
        } else if duplicatePlayer() {
            showAlert(message: "Duplicate players in squad")
        } else {
            if vc == nil {
                vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OldPitchViewController") as? OldPitchViewController
            } else {
                vc?.squad = players
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
    }
    
    func duplicatePlayer() -> Bool {
        var duplicatePlayer = false
        var duplicates = [Player]()
        players.forEach { (player) in
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
        players.forEach { (player) in
            if player.captain {
                numberOfCaptains += 1
            }
        }
        return numberOfCaptains > 1
    }
    
    func missingInfo() -> Bool {
        var missing = false
        players.forEach { (player) in
            if player.name == "" || player.number == "" {
                missing = true
                return
            }
        }
        return missing
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setActiveCell(cell: SquadTableViewCell) {
        self.activeCell = cell
    }
    
    func setCaptain(cell: SquadTableViewCell) {
        cell.captain.toggle()
        guard let indexPath = squadTableView.indexPath(for: cell) else {
            return
        }
        players[indexPath.row].captain = cell.captain
    }
    
    func updatePlayerInfo(cell: SquadTableViewCell) {
        guard let indexPath = squadTableView.indexPath(for: cell),
            let name = cell.nameTextField.text,
            let number = cell.numberTextField.text else {
            return
        }
        let player = players[indexPath.row]
        player.name = name
        player.number = number
    }

}