//
//  RootViewController.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 08/05/2020.
//  Copyright © 2020 Jake Renshaw. All rights reserved.
//

import UIKit
import SnapKit

class RootViewController: UIViewController {
    
    @IBOutlet var mainContainerView: UIView!
    @IBOutlet var tabContainerView: UIView!
    @IBOutlet var pageContainerView: UIView!
    
    var currentViewController: UIViewController?
    
    lazy var squadViewController: SquadViewController = {
        SquadViewController(squadStore: self.squadStore, nibName: "SquadViewController", bundle: nil)
    }()
    
    lazy var pitchViewController: PitchViewController = {
        let pitch = PitchViewController(squadStore: self.squadStore, nibName: "PitchViewController", bundle: nil)
        pitch.delegate = self
        return pitch
    }()
    
    lazy var menuViewController: MenuViewController = {
        let menu = MenuViewController(menuItems: [.loadSquad, .saveSquad, .info], nibName: "MenuViewController", bundle: nil)
        menu.delegate = self
        return menu
    }()
    
    lazy var tabViewController: TabViewController = {
        let tabViewController = TabViewController(tabs: [.squad, .pitch, .menu])
        tabViewController.delegate = self
        return tabViewController
    }()
    
    lazy var squadStore: SquadStore = {
        SquadStore()
    }()
    
    lazy var privateDatabase: PrivateDatabase = {
        let privateDatabase = PrivateDatabase()
        privateDatabase.delegate = self
        return privateDatabase
    }()
    
    lazy var alertPresenter: AlertPresenter = {
        AlertPresenter(presentationController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTabComponent()
    }
    
    func addTabComponent() {
        self.addChild(tabViewController)
        self.tabContainerView.addSubview(tabViewController.view)
        tabViewController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension RootViewController: TabViewControllerDelegate {
    func setPage(tab: TabType) {
        currentViewController?.removeFromParent()
        currentViewController?.view.removeFromSuperview()
        switch tab {
        case .squad:
            currentViewController = self.squadViewController
        case .pitch:
            currentViewController = self.pitchViewController
        case .menu:
            currentViewController = self.menuViewController
        }
        self.addChild(currentViewController!)
        self.pageContainerView.addSubview(currentViewController!.view)
        currentViewController?.view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
    }
}

extension RootViewController: PitchViewControllerDelegate {
    func error(error: SquadError) {
        switch error {
        case .missingInfo:
            let missingInfoContent = AlertContent(
                title: "Missing Info",
                message: "A player has a missing name/number in the squad",
                actions: [.cancel(completion: { (_) in
                    self.tabViewController.setCurrentTab(currentTab: .squad)
                })]
            )
            self.alertPresenter.presentAlert(alertContent: missingInfoContent)
        case .multipleCaptains:
            let multipleCaptainsContent = AlertContent(
                title: "Multiple Captains",
                message: "There are multiple captains selected in the sqaud",
                actions: [.cancel(completion: { (_) in
                    self.tabViewController.setCurrentTab(currentTab: .squad)
                })]
            )
            self.alertPresenter.presentAlert(alertContent: multipleCaptainsContent)
        case .duplicatePlayers:
            let duplicatePlayersContent = AlertContent(
                title: "Duplicate Players",
                message: "There are duplicate players in the squad",
                actions: [.cancel(completion: { (_) in
                    self.tabViewController.setCurrentTab(currentTab: .squad)
                })]
            )
            self.alertPresenter.presentAlert(alertContent: duplicatePlayersContent)
        }
    }
}

extension RootViewController: MenuViewControllerDelegate {
    func loadSquad() {
        self.tabViewController.setCurrentTab(currentTab: .squad)
        self.privateDatabase.loadSquad()
    }

    func saveSquad() {
        self.privateDatabase.saveSquad(squad: self.squadStore.squad)
    }
    
    func showInfo() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let infoContent = AlertContent(
            title: "TeamSheetLite",
            message: "App Version = \(appVersion) \n Icons from https://icons8.com",
            actions: [.cancel()]
        )
        self.alertPresenter.presentAlert(alertContent: infoContent)
    }
}

extension RootViewController: PrivateDatabaseDelegate {

    func presentRecordExistsError() {
        let recordExistsContent = AlertContent(
            title: "Duplicate Squad Name",
            message: "The Squad name chosen already exists. Please choose another",
            actions: [.ok]
        )
        self.alertPresenter.presentAlert(alertContent: recordExistsContent)
    }

    func presentSuccessAlert(squadName: String) {
        let cloudSignInContent = AlertContent(
            title: "Squad Saved",
            message: "\(squadName) has been saved successfully",
            actions: [.ok]
        )
        self.alertPresenter.presentAlert(alertContent: cloudSignInContent)
    }

    func presentCloudSignInError() {
        let cloudSignInContent = AlertContent(
            title: "Sign into iCloud",
            message: "Please sign in to iCloud to load/save squads.",
            actions: [.cancel(), .settings(preferred: true)]
        )
        self.alertPresenter.presentAlert(alertContent: cloudSignInContent)
    }

    func presentSquadLoaderAlert(squadNames: [String], completion: @escaping ((String?) -> Void)) {
        let squadLoaderContent = AlertContent(
            title: "Select Squad",
            message: "Please select a squad to load",
            actions: [
                .cancel(completion: completion),
                .squad(squadNames: squadNames, completion: completion)
            ]
        )
        self.alertPresenter.presentAlert(alertContent: squadLoaderContent)
    }

    func presentSquadNameAlert(completion: @escaping ((String?) -> Void)) {
        if let squadName = (navigationItem.titleView as? UITextField)?.text {
            completion(squadName)
        } else {
            let squadNameContent = AlertContent(
                title: "Squad Name",
                message: "Please enter the Squad Name",
                actions: [
                    .cancel(completion: completion),
                    .save(completion: completion)
                ]
            )
            self.alertPresenter.presentAlert(alertContent: squadNameContent)
        }
    }

    func fetchedPlayers(players: [Player]) {
        DispatchQueue.main.async {
            self.squadStore.squad = players
            self.squadViewController.reloadData()
        }
    }
}
