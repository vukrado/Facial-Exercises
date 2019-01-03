//
//  ProgressViewController.swift
//  Facial Exercises
//
//  Created by De MicheliStefano on 04.01.19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController {

    // MARK: - Private properties
    
    private lazy var historyCollectionView: ExerciseHistoryCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = ExerciseHistoryCollectionView(frame: .zero, collectionViewLayout: layout)
        cv.layer.cornerRadius = 16
        cv.layer.masksToBounds = true
        
        return cv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colors: [UIColor.rgb(red: 166, green: 255, blue: 203).cgColor, UIColor.rgb(red: 18, green: 216, blue: 250).cgColor, UIColor.rgb(red: 31, green: 162, blue: 255).cgColor], locations: [0.0, 0.5, 1.0], startPoint: CGPoint(x: 1, y: 0), endPoint: CGPoint(x: 0, y: 1))
        
        setupViews()
    }

    // MARK: - Configuration
    
    private func setupViews() {
        view.addSubview(historyCollectionView)
        historyCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0))
    }
    
}
