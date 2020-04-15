//
//  Colors.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 15/04/2020.
//  Copyright © 2020 Jake Renshaw. All rights reserved.
//

import Foundation
import UIKit

class Colors {
    static let colors : [UIColor] = [.white, .red, .blue, .green, .yellow, .purple, .orange]
    
    static func newColor(current: UIColor?) -> UIColor {
        guard let current = current,
            let index = colors.index(of: current) else {
            return .white
        }
        let nextColorIndex = index + 1
        if colors.indices.contains(nextColorIndex) {
            return colors[nextColorIndex]
        } else {
            return .white
        }
    }
}
