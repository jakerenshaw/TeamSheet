//
//  PlayerIcon.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 07/04/2019.
//  Copyright © 2019 Jake Renshaw. All rights reserved.
//

import UIKit

protocol PlayerIconDelegate: class {
    func draggedView(_ sender:UIPanGestureRecognizer, viewDrag: PlayerIcon)
    func updatePlayerPositon(view: PlayerIcon, x: CGFloat, y: CGFloat)
    func updatePlayerTeamColor(view: PlayerIcon, color: UIColor)
}

class PlayerIcon: UIView, UIGestureRecognizerDelegate {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    let name: String
    let number: String
    let captain: Bool
    var panGesture: UIPanGestureRecognizer?
    var tapGesture: UITapGestureRecognizer?
    weak var delegate: PlayerIconDelegate?
    
    init(frame: CGRect, name: String, number: String, captain: Bool) {
        self.name = name
        self.number = number
        self.captain = captain
        super.init(frame: frame)
        Bundle.main.loadNibNamed("PlayerIcon", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setupView()
        panGesture?.delegate = self
        tapGesture?.delegate = self
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(updateBackgroundColor(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(panGesture!)
        self.addGestureRecognizer(tapGesture!)
        self.nameLabel.text = name
        self.numberLabel.text = number
        if captain {
            setCaptain()
        } else {
            removeCaptain()
        }
        self.containerView.layer.borderWidth = 2
        self.containerView.layer.cornerRadius = self.containerView.bounds.size.width/2
        self.nameLabel.sizeToFit()
        self.numberLabel.sizeToFit()
        let height = self.nameLabel.intrinsicContentSize.height + self.containerView.frame.height
        let width = (self.nameLabel.intrinsicContentSize.width > self.containerView.frame.width) ? self.nameLabel.intrinsicContentSize.width : self.containerView.frame.width
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: width, height: height)
    }
    
    func setCaptain() {
        self.containerView.layer.borderColor = UIColor.yellow.cgColor
    }
    
    func removeCaptain() {
        self.containerView.layer.borderColor = UIColor.black.cgColor
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        self.delegate?.draggedView(sender, viewDrag: self)
        if(sender.state == .ended)
        {
            let playerX = self.frame.origin.x + (self.frame.width / 2)
            let playerY = self.frame.origin.y + (self.frame.height / 2)
            self.delegate?.updatePlayerPositon(view: self, x: playerX, y: playerY)
        }
    }
    
    @objc func updateBackgroundColor(_ sender:UITapGestureRecognizer){
        let newColor = Colors.newColor(current: self.containerView.backgroundColor)
        self.containerView.backgroundColor = newColor
        self.delegate?.updatePlayerTeamColor(view: self, color: newColor)
    }
    
    override var bounds: CGRect {
        didSet {
            if self.containerView != nil {
                self.containerView.layer.cornerRadius = self.containerView.bounds.size.width/2
            }
        }
    }
    
}
