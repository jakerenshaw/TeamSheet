//
//  AlertPresenter.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 26/04/2020.
//  Copyright © 2020 Jake Renshaw. All rights reserved.
//

import Foundation
import UIKit

struct AlertContent {
    let title: String
    let message: String
    let actions : [AlertActionType]
}

enum AlertActionType {
    case cancel(completion: ((String?) -> Void)? = nil, preferred: Bool = false)
    case settings(preferred: Bool = false)
    case squad(squadNames: [String], completion: ((String?) -> Void)? = nil, preferred: Bool = false)
    case save(completion: ((String?) -> Void)? = nil, preferred: Bool = false)
    case ok
}

class AlertPresenter: NSObject {
    
    let presentationController: UIViewController
    
    init(presentationController: UIViewController) {
        self.presentationController = presentationController
    }
    
    func presentAlert(alertContent: AlertContent) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: alertContent.title, message: alertContent.message, preferredStyle: .alert)
            self.addButtons(
                alert: alert,
                actions: alertContent.actions
            )
            self.presentationController.present(alert, animated: true, completion: nil)
        }
    }
    
    func addButtons(
        alert: UIAlertController,
        actions: [AlertActionType]
    ) {
        actions.forEach { (alertActionType) in
            switch alertActionType {
            case .cancel(completion: let completion, preferred: let preferred):
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
                    if let completion = completion {
                        completion(nil)
                    }
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(cancelAction)
                if preferred {
                    alert.preferredAction = cancelAction
                }
            case .settings(preferred: let preferred):
                let settingsAction = UIAlertAction(title: "Go to Settings", style: .default) { (_) in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                    }
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(settingsAction)
                if preferred {
                    alert.preferredAction = settingsAction
                }
            case .squad(squadNames: let squadNames, completion: let completion, preferred: _):
                squadNames.forEach { (squadName) in
                    let alertAction = UIAlertAction(title: squadName, style: .default) { (_) in
                        if let completion = completion {
                            completion(squadName)
                        }
                        alert.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(alertAction)
                }
            case .save(completion: let completion, preferred: let preferred):
                alert.addTextField {(_) in }
                let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
                    var name: String?
                    if let textField = alert.textFields?.first,
                        let squadName = textField.text {
                        name = squadName
                    }
                    if let completion = completion {
                        completion(name)
                    }
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(saveAction)
                if preferred {
                    alert.preferredAction = saveAction
                }
            case .ok:
                let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(okAction)
            }
        }
    }
}
