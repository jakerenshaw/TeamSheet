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
}

protocol TabViewControllerDelegate: class {
    func setPage(tab: TabType)
}

class TabViewController: UIViewController {
    
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
        self.setInitialTab()
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
            }
        }
    }
    
    func setInitialTab() {
        tabStackView.arrangedSubviews.forEach { (view) in
            guard let tab = view as? TabView else {
                return
            }
            if tab.tabType == .squad {
                tab.selected = true
            }
        }
    }
}

extension TabViewController: TabViewDelegate {
    func setSelectedTab(tabType: TabType) {
        self.delegate?.setPage(tab: tabType)
    }
}
