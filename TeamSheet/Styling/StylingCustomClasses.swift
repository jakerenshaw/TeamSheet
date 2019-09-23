//
//  StylingCustomClasses.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 23/09/2019.
//  Copyright © 2019 Jake Renshaw. All rights reserved.
//

import UIKit

class PlayersTableView: UITableView {
    @objc dynamic var tableColor: UIColor? {
        set {
            self.backgroundColor = newValue
        } get {
            return UIColor.white
        }
    }
    @objc dynamic var tableSeparatorColor: UIColor? {
        set {
            self.separatorColor = newValue
        } get {
            return UIColor.black
        }
    }
}
class TeamMateTableViewCellButton: UIButton {}
class TeamMateTableViewCellTextField: UITextField {}
