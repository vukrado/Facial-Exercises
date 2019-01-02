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
        
        
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        setupViews()
    }
    
    private func setupViews() {
        addSubview(exerciseLabel)
        exerciseLabel.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        exerciseLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
