//
//  Errors.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 26/04/2020.
//  Copyright © 2020 Jake Renshaw. All rights reserved.
//

import Foundation

enum CloudKitError: String {
    case authenticateAccount = "This request requires an authenticated account"
    case recordExists = "record to insert already exists"
}
