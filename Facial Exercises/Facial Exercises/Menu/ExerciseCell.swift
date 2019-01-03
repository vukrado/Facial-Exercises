//
//  ExerciseCell.swift
//  Facial Exercises
//
//  Created by Simon Elhoej Steinmejer on 03/01/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import UIKit

class ExerciseCell: UICollectionViewCell {
    
    let exerciseLabel: UILabel = {
        let label = UILabel()
        label.text = "Exercise name"
        label.textAlignment = .center
        label.textColor = .white
        label.sizeToFit()
        label.font = Appearance.appFont(style: .title1, size: 22)
        
        return label
    }()
    
    let exerciseImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "test-face").withRenderingMode(.alwaysOriginal)
//        iv.tintColor = .white
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let exerciseDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Some exercise description uihfiuwehf iuhewfiuwehf iwuhfwei uqwpdwq[dpokpqw pqwodk qpdjqo ijq ojqw odijqwod j ijiodq"
        label.textColor = .white
        label.numberOfLines = 0
        label.font = Appearance.appFont(style: .body, size: 12)
        label.sizeToFit()
        label.textAlignment = .center
        
        return label
    }()
    
    let selectedImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "selected").withRenderingMode(.alwaysTemplate))
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        
        return iv
    }()
    
    let blurEffect: UIVisualEffectView = {
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        frost.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return frost
    }()
    
    override var isSelected: Bool {
        didSet {
            selectedImageViewTrailingAnchor?.constant = isSelected ? -12 : 42
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.layoutIfNeeded()
                
            }, completion: nil)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        layer.masksToBounds = true
        setupViews()
    }
    
    var selectedImageViewTrailingAnchor: NSLayoutConstraint?
    
    private func setupViews() {
        addSubview(blurEffect)
        blurEffect.fillSuperview()
        
        addSubview(exerciseLabel)
        exerciseLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 24, left: 0, bottom: 0, right: 0))
        exerciseLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(selectedImageView)
        selectedImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: 40, height: 40))
        selectedImageView.centerYAnchor.constraint(equalTo: exerciseLabel.centerYAnchor).isActive = true
        selectedImageViewTrailingAnchor = selectedImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 42)
        selectedImageViewTrailingAnchor?.isActive = true
        
        addSubview(exerciseImageView)
        exerciseImageView.centerInSuperview(size: CGSize(width: 150, height: 150))
        
        addSubview(exerciseDescriptionLabel)
        exerciseDescriptionLabel.anchor(top: exerciseImageView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 12, left: 20, bottom: 12, right: 20))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
