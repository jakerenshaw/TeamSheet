//
//  Player.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 02/02/2020.
//  Copyright © 2020 Jake Renshaw. All rights reserved.
//

import Foundation
import UIKit

enum PlayerType {
    case squad
    case opposition
}

class Player: Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.name == rhs.name && lhs.number == rhs.number
    }
    
    var name: String
    var number: String
    var captain: Bool
    var x: CGFloat
    var y: CGFloat
    var teamColor: UIColor
    
    init(
        name: String,
        number: String,
        captain: Bool,
        x: CGFloat,
        y: CGFloat,
        teamColor: UIColor
    ) {
        self.name = name
        self.number = number
        self.captain = captain
        self.x = x
        self.y = y
        self.teamColor = teamColor
    }
    
    init(
        x: CGFloat,
        y: CGFloat
    ) {
        self.name = ""
        self.number = ""
        self.captain = false
        self.x = x
        self.y = y
        self.teamColor = .white
    }
}
