//
//  MenuViewController.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 09/05/2020.
//  Copyright © 2020 Jake Renshaw. All rights reserved.
//

import UIKit

enum MenuItemType {
    case toggleOpposition
    case loadSquad
    case saveSquad
    case info
}

struct MenuContent {
    let imageName: String
    let title: String
}

protocol MenuViewControllerDelegate: class {
    func toggleOpposition()
    func loadSquad()
    func saveSquad()
    func showInfo()
}

class MenuViewController: UIViewController {
    
    @IBOutlet var menuTableView: UITableView!
    
    weak var delegate: MenuViewControllerDelegate?
    
    let menuItems: [MenuItemType]
    
    init(menuItems: [MenuItemType], nibName: String?, bundle: Bundle?) {
        self.menuItems = menuItems
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuTableView.delegate = self
        self.menuTableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as? MenuTableViewCell
        cell?.delegate = self
        switch self.menuItems[indexPath.row] {
        case .toggleOpposition:
            cell?.menuItemType = .toggleOpposition
            cell?.menuText.text = "Add/Remove Opposition"
            cell?.menuImage.image = UIImage(named: "menu_opposition")
        case .loadSquad:
            cell?.menuItemType = .loadSquad
            cell?.menuText.text = "Load Squad"
            cell?.menuImage.image = UIImage(named: "menu_download")
        case .saveSquad:
            cell?.menuItemType = .saveSquad
            cell?.menuText.text = "Save Squad"
            cell?.menuImage.image = UIImage(named: "menu_upload")
        case .info:
            cell?.menuItemType = .info
            cell?.menuText.text = "App Info"
            cell?.menuImage.image = UIImage(named: "menu_info")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension MenuViewController: MenuTableViewCellDelegate {
    func menuItemTapped(menuItemType: MenuItemType) {
        switch menuItemType {
        case .toggleOpposition:
            self.delegate?.toggleOpposition()
        case .loadSquad:
            self.delegate?.loadSquad()
        case .saveSquad:
            self.delegate?.saveSquad()
        case .info:
            self.delegate?.showInfo()
        }
    }
}
