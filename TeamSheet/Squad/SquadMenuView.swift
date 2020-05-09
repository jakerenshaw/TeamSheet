//
//  SquadMenuView.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 08/05/2020.
//  Copyright © 2020 Jake Renshaw. All rights reserved.
//

import Foundation
import UIKit

protocol SquadMenuViewDelegate: class {
    func addPlayers(numberOfPlayers: Int)
}

class SquadMenuView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var addPlayersTextField: UITextField!
    @IBOutlet var addPlayersButton: UIButton!
    
    weak var delegate: SquadMenuViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("SquadMenuView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addPlayersTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func addPlayers(_ sender: UIButton) {
        if let text = addPlayersTextField.text,
            let number = Int(text) {
            self.delegate?.addPlayers(numberOfPlayers: number)
        }
    }
    
}

extension SquadMenuView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.addPlayersTextField,
            let text = self.addPlayersTextField.text,
            string != "" {
            return text.count < 2 && string != " "
        } else {
            return true
        }
    }
}
