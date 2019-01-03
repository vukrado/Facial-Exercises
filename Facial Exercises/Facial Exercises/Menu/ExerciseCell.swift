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
        label.font = Appearance.appFont(with: 22)
        
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
        label.font = Appearance.appFont(with: 12)
        label.sizeToFit()
        label.textAlignment = .center
        
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        layer.cornerRadius = 16
        setupViews()
    }
    
    private func setupViews() {
        addSubview(exerciseLabel)
        exerciseLabel.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        exerciseLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(exerciseImageView)
        exerciseImageView.centerInSuperview(size: CGSize(width: 150, height: 150))
        
        addSubview(exerciseDescriptionLabel)
        exerciseDescriptionLabel.anchor(top: exerciseImageView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 12, left: 20, bottom: 12, right: 20))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
