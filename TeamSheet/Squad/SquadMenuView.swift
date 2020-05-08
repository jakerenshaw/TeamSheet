//
//  SquadMenuView.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 08/05/2020.
//  Copyright © 2020 Jake Renshaw. All rights reserved.
//

import Foundation
import UIKit

class SquadMenuView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var addPlayersTextField: UITextField!
    @IBOutlet var addPlayersButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("SquadMenuView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func addPlayers(_ sender: UIButton) {
    }
    
}
