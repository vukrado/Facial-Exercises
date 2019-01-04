//
//  ExerciseCompleteView.swift
//  Facial Exercises
//
//  Created by Simon Elhoej Steinmejer on 04/01/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import UIKit
import Lottie

class ExerciseCompleteView {
    
    lazy var celebrationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.alpha = 0
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(dismiss)))
        
        return view
    }()
    
    let tapLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap to continue"
        label.textAlignment = .center
        label.textColor = .selectedGreen
        label.font = Appearance.appFont(style: .title1, size: 18)
        
        return label
    }()
    
    let animationView: LOTAnimationView = {
        let lav = LOTAnimationView()
        lav.setAnimation(named: "star_success")
        lav.alpha = 0
        
        return lav
    }()
    
    let blackBackgroundView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        
        return view
    }()
    
    func showLoadingAnimation() {
        if let keywindow = UIApplication.shared.keyWindow {
            
            keywindow.addSubview(blackBackgroundView)
            blackBackgroundView.fillSuperview()
            blackBackgroundView.addSubview(celebrationView)
            celebrationView.addSubview(tapLabel)
            tapLabel.anchor(top: nil, leading: celebrationView.leadingAnchor, bottom: celebrationView.bottomAnchor, trailing: celebrationView.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 12, right: 8))
            celebrationView.addSubview(animationView)
            animationView.anchor(top: celebrationView.topAnchor, leading: celebrationView.leadingAnchor, bottom: tapLabel.topAnchor, trailing: celebrationView.trailingAnchor)
            celebrationView.centerInSuperview(size: CGSize(width: 250, height: 250))
            
            UIView.animate(withDuration: 0.4, animations: {
                
                self.celebrationView.alpha = 1
                self.blackBackgroundView.alpha = 1
                self.animationView.alpha = 1
                
            }) { (completed) in
                
                self.animationView.play()
            }
        }
    }
    
    @objc private func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            
            self.celebrationView.alpha = 0
            self.blackBackgroundView.alpha = 0
            self.animationView.alpha = 0
            
        }) { (completed) in
            
            self.blackBackgroundView.removeFromSuperview()
        }
    }
}

