//
//  MenuTableViewCell.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 09/05/2020.
//  Copyright © 2020 Jake Renshaw. All rights reserved.
//

import UIKit

protocol MenuTableViewCellDelegate: class {
    func menuItemTapped(menuItemType: MenuItemType)
}

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet var menuText: UILabel!
    @IBOutlet var menuImage: UIImageView!
    var menuItemType: MenuItemType!
    weak var delegate: MenuTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        var currentTintColor: UIColor = .black
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                currentTintColor = .white
            }
        }
        self.menuImage.tintColor = currentTintColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.delegate?.menuItemTapped(menuItemType: self.menuItemType)
            self.isSelected = false
        }
    }
    
}
