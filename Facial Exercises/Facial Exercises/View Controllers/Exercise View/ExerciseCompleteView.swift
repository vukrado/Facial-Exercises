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
    
    let animationView: LOTAnimationView = {
        let lav = LOTAnimationView()
        lav.setAnimation(named: "star_success")
        lav.layer.cornerRadius = 16
        lav.layer.masksToBounds = true
        lav.alpha = 0
        lav.animationSpeed = 1.5
        
        return lav
    }()
    
    let blackBackgroundView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    func showCelebrationView() {
        if let keywindow = UIApplication.shared.keyWindow {
            keywindow.addSubview(blackBackgroundView)
            blackBackgroundView.fillSuperview()
            blackBackgroundView.addSubview(animationView)
            animationView.centerInSuperview(size: CGSize(width: 250, height: 250))
            
            UIView.animate(withDuration: 0.4, animations: {
                
                self.blackBackgroundView.alpha = 1
                self.animationView.alpha = 1
                
            }) { (completed) in
                
                self.animationView.play(completion: { (_) in
                    self.dismiss()
                })
            }
        }
    }
    
    @objc private func dismiss() {
        print("test")
        UIView.animate(withDuration: 0.3, animations: {
            
            self.blackBackgroundView.alpha = 0
            self.animationView.alpha = 0
            
        }) { (completed) in
            
            self.blackBackgroundView.removeFromSuperview()
        }
    }
}

