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

class TabViewController: UIViewController {
    
    @IBOutlet weak var tabStackView: UIStackView!
    
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
        addTabs()
    }
    
    func addTabs() {
        tabs.forEach { (tab) in
            let newTab = TabView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            tabStackView.addSubview(newTab)
            switch tab {
            case .squad:
                newTab.tabName.text = "Squad"
                newTab.tabImage.image = UIImage(named: "tab_squad")
            case .pitch:
                newTab.tabName.text = "Pitch"
                newTab.tabImage.image = UIImage(named: "tab_pitch")
            }
        }
    }
}
