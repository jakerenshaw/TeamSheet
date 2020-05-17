//
//  ReachabilitySwift.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 17/05/2020.
//  Copyright © 2020 Jake Renshaw. All rights reserved.
//

import Foundation
import Reachability

enum Connection: String {
    case update
    case connected
    case disconnected
}

class ReachabilitySwift: NSObject {
    
    let reachability = try! Reachability()
    
    override init() {
        super.init()
        self.start()
        self.addNotifier()
    }
    
    func start() {
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }
    
    func addNotifier() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi, .cellular:
            NotificationCenter.default.post(name: NSNotification.Name(Connection.update.rawValue), object: Connection.connected)
        case .unavailable:
            NotificationCenter.default.post(name: NSNotification.Name(Connection.update.rawValue), object: Connection.disconnected)
        case .none:
            break
        }
    }
}
