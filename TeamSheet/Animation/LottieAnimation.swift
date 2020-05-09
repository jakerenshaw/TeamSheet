//
//  LoadingScreen.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 09/05/2020.
//  Copyright © 2020 Jake Renshaw. All rights reserved.
//

import Foundation
import Lottie
import SnapKit

class LoadingScreen: NSObject {
    
    let loadingView: UIView
    let animationView: AnimationView
    
    init(loadingView: UIView) {
        
        self.loadingView = loadingView
        self.animationView = AnimationView(name: "football_bouncing")
        animationView.loopMode = .loop
        super.init()
    }
    
    func add() {
        loadingView.layer.backgroundColor = UIColor.gray.withAlphaComponent(0.8).cgColor
        loadingView.addSubview(animationView)
        animationView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(192)
            make.width.equalTo(90)
        }
        animationView.play()
    }
    
    func remove(completion: @escaping (()-> Void)) {
        UIView.animate(withDuration: 1, animations: {
            self.loadingView.layer.opacity = 0
        }) { (_) in
            self.animationView.removeFromSuperview()
            self.animationView.stop()
            completion()
        }
    }
}
