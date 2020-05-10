//
//  SquadTableViewCell.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 07/04/2019.
//  Copyright © 2019 Jake Renshaw. All rights reserved.
//

import UIKit

protocol SquadTableViewCellDelegate: class {
    func setActiveCell(cell: SquadTableViewCell)
    func setCaptain(cell: SquadTableViewCell)
    func updatePlayerInfo(cell: SquadTableViewCell)
}

class SquadTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var captainButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    weak var delegate: SquadTableViewCellDelegate?
    var captain = false {
        didSet {
            if self.captain {
                self.captainButton.backgroundColor = .yellow
            } else {
                self.captainButton.backgroundColor = .white
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameTextField.delegate = self
        self.numberTextField.delegate = self
        self.numberTextField.addDoneToolbar()
        self.createCaptainButton()
    }
    
    func createCaptainButton() {
        self.captainButton.setTitleColor(.black, for: .normal)
        self.captainButton.layer.cornerRadius = self.captainButton.bounds.size.width / 2
        self.captainButton.layer.borderColor = UIColor.black.cgColor
        self.captainButton.layer.borderWidth = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.delegate?.setActiveCell(cell: self)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.updatePlayerInfo(cell: self)
    }
    
    @IBAction func captainSelected(_ sender: Any) {
        self.delegate?.setCaptain(cell: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.numberTextField,
            let text = self.numberTextField.text,
            string != "" {
            return text.count < 2 && string != " "
        } else {
            return true
        }
    }
    
    func clean() {
        self.captain = false
        self.nameTextField.text = ""
        self.numberTextField.text = ""
    }
    
    override func prepareForReuse() {
        self.clean()
        super.prepareForReuse()
    }
}
