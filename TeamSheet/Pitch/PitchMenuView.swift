//
//  PitchMenuView.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 13/04/2020.
//  Copyright © 2020 Jake Renshaw. All rights reserved.
//

import Foundation
import UIKit

protocol PitchMenuViewDelegate: class {
    func toggleOppostion(add: Bool)
    func toggleTitle(add: Bool)
    func loadSquad()
    func saveSquad()
}

class TitleButton: UIButton {
    var switchTitle = false {
        didSet {
            if self.switchTitle {
                self.setTitle("- Title", for: .normal)
            } else {
                self.setTitle("+ Title", for: .normal)
            }
        }
    }
}

class OppositionButton: UIButton {
    var switchOpposition = false {
        didSet {
            if self.switchOpposition {
                self.setTitle("- Opposition", for: .normal)
            } else {
                self.setTitle("+ Opposition", for: .normal)
            }
        }
    }
}

class PitchMenuView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var stackViewContainerView: UIView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var titleButton: TitleButton!
    @IBOutlet weak var oppositionButton: OppositionButton!
    @IBOutlet weak var loadSquadButton: UIButton!
    @IBOutlet weak var saveSquadButton: UIButton!
    
    weak var delegate: PitchMenuViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("PitchMenuView", owner: self, options: nil)
        self.updateFrame()
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateFrame() {
        self.frame = CGRect(x: self.frame.origin.x - self.stackViewContainerView.frame.width, y: self.frame.origin.y, width: self.stackViewContainerView.frame.width, height: self.stackViewContainerView.frame.height)
    }
    
    @IBAction func toggleTitle(_ sender: UIButton) {
        self.titleButton.switchTitle.toggle()
        self.delegate?.toggleTitle(add: self.titleButton.switchTitle)
    }
    
    @IBAction func toggleOpposition(_ sender: UIButton) {
        self.oppositionButton.switchOpposition.toggle()
        self.delegate?.toggleOppostion(add: self.oppositionButton.switchOpposition)
    }
    
    @IBAction func loadSquad(_ sender: UIButton) {
        self.delegate?.loadSquad()
    }
    
    @IBAction func saveSquad(_ sender: UIButton) {
        self.delegate?.saveSquad()
    }
    
}
