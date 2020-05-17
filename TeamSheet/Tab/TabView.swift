//
//  TabView.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 08/05/2020.
//  Copyright © 2020 Jake Renshaw. All rights reserved.
//

import Foundation
import UIKit

protocol TabViewDelegate: class {
    func setCurrentTab(currentTab: TabType)
    var darkModeColor: UIColor? { get }
}

class TabView: UIView, UIGestureRecognizerDelegate {
    
    weak var delegate: TabViewDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tabName: UILabel!
    @IBOutlet weak var tabImage: UIImageView!
    var tabType: TabType!
    var selected: Bool = false {
        didSet {
            if selected {
                setSelected()
            } else {
                setUnselected()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("TabView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func viewTapped() {
        self.delegate?.setCurrentTab(currentTab: self.tabType)
    }
    
    func setSelected() {
        self.tintColor = .green
    }
    
    func setUnselected() {
        self.tintColor = self.delegate?.darkModeColor
    }
}
