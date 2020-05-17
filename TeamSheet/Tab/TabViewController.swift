//
//  TabViewController.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 08/05/2020.
//  Copyright © 2020 Jake Renshaw. All rights reserved.
//

import UIKit

enum TabType: String {
    case squad
    case pitch
    case menu
}

protocol TabViewControllerDelegate: class {
    func setPage(tab: TabType)
    var darkModeColor: UIColor { get }
}

class TabViewController: UIViewController, TabViewDelegate {
    
    var darkModeColor: UIColor? {
        self.delegate?.darkModeColor
    }
    
    @IBOutlet weak var tabStackView: UIStackView!
    weak var delegate: TabViewControllerDelegate?
    
    let tabs: [TabType]
    
    init(tabs: [TabType]) {
        self.tabs = tabs
        super.init(nibName: "TabViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTabs()
        self.setCurrentTab(currentTab: .squad)
    }
    
    func addTabs() {
        tabs.forEach { (tab) in
            let newTab = TabView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            newTab.delegate = self
            tabStackView.addArrangedSubview(newTab)
            switch tab {
            case .squad:
                newTab.tabType = .squad
                newTab.tabName.text = "Squad"
                newTab.tabImage.image = UIImage(named: "tab_squad")
            case .pitch:
                newTab.tabType = .pitch
                newTab.tabName.text = "Pitch"
                newTab.tabImage.image = UIImage(named: "tab_pitch")
            case .menu:
                newTab.tabType = .menu
                newTab.tabName.text = "Menu"
                newTab.tabImage.image = UIImage(named: "menu")
            }
        }
    }
    
    func setCurrentTab(currentTab: TabType) {
        tabStackView.arrangedSubviews.forEach { (view) in
            guard let tab = view as? TabView else {
                return
            }
            if tab.tabType == currentTab {
                tab.selected = true
                self.delegate?.setPage(tab: currentTab)
            } else {
                tab.selected = false
            }
        }
    }
}
