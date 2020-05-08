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
        SquadViewController(nibName: "SquadViewController", bundle: nil)
    }()
    
    lazy var pitchViewController: PitchViewController = {
        PitchViewController(nibName: "PitchViewController", bundle: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTabComponent()
    }
    
    func addTabComponent() {
        let tabViewController = TabViewController(tabs: [.squad, .pitch])
        tabViewController.delegate = self
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
        }
        self.addChild(currentViewController!)
        self.pageContainerView.addSubview(currentViewController!.view)
        currentViewController?.view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
    }
}
