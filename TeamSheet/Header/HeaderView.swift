//
//  HeaderView.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 09/05/2020.
//  Copyright © 2020 Jake Renshaw. All rights reserved.
//

import Foundation
import UIKit

class HeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
