//
//  Player.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 02/02/2020.
//  Copyright © 2020 Jake Renshaw. All rights reserved.
//

import Foundation
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
    
    init() {
        self.name = ""
        self.number = ""
        self.captain = false
        self.x = 0
        self.y = 0
    }
}
