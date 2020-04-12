//
//  TeamMateTableViewCell.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 07/04/2019.
//  Copyright © 2019 Jake Renshaw. All rights reserved.
//

import UIKit

protocol TeamMateTableViewCellDelegate: class {
    func setActiveCell(cell: TeamMateTableViewCell)
    func setCaptain(cell: TeamMateTableViewCell)
    func updatePlayerInfo(cell: TeamMateTableViewCell)
}

extension UITextField {
    func addDoneToolbar(onDone: (target: Any, action: Selector)? = nil) {
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped() { self.resignFirstResponder() }
}

class TeamMateTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    override func isEqual(_ object: Any?) -> Bool {
        return (nameTextField.text == (object as? TeamMateTableViewCell)?.nameTextField.text) && (numberTextField.text == (object as? TeamMateTableViewCell)?.numberTextField.text)
    }
    
    @IBOutlet weak var captainButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    weak var delegate: TeamMateTableViewCellDelegate?
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
    
    override func prepareForReuse() {
        self.captain = false
        self.nameTextField.text = ""
        self.numberTextField.text = ""
    }
}
