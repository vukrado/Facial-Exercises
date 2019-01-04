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
    
    private lazy var mainTitle: UILabel = {
        let label = UILabel()
        label.font = Appearance.boldAppFont(style: .body, size: 30.0)
        label.text = "Progress Summary"
        label.textColor = .white
        return label
    }()
    
    private lazy var chartSectionTitle: UILabel = {
        let label = UILabel()
        label.font = Appearance.appFont(style: .body, size: 12.0)
        label.text = "PROGRESS CHART"
        label.textColor = .white
        return label
    }()
    
    private lazy var chartCollectionView: ChartCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = ChartCollectionView(frame: .zero, collectionViewLayout: layout)
        
        return cv
    }()
    
    private lazy var exerciseHistoryTitle: UILabel = {
        let label = UILabel()
        label.font = Appearance.appFont(style: .body, size: 12.0)
        label.text = "EXERCISE HISTORY"
        label.textColor = .white
        return label
    }()
    
    private lazy var exerciseHistoryCollectionView: ExerciseHistoryCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = ExerciseHistoryCollectionView(frame: .zero, collectionViewLayout: layout)
        cv.layer.cornerRadius = 16
        cv.layer.masksToBounds = true
        
        return cv
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    private let padding: CGFloat = 12.0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colors: [UIColor.rgb(red: 67, green: 206, blue: 162).cgColor, UIColor.rgb(red: 24, green: 90, blue: 157).cgColor], locations: [0.0, 1.0], startPoint: CGPoint(x: 1, y: 0), endPoint: CGPoint(x: 0, y: 1))
        
        setupViews()
    }
    
    // MARK: - User Actions
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Configuration
    
    private func setupViews() {
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: padding, left: 0, bottom: 0, right: padding), size: CGSize(width: 13, height: 13))
        
        view.addSubview(mainTitle)
        mainTitle.anchor(top: closeButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0.0, left: padding, bottom: padding, right: padding))
        
        view.addSubview(chartSectionTitle)
        chartSectionTitle.anchor(top: mainTitle.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
        
        view.addSubview(chartCollectionView)
        chartCollectionView.anchor(top: chartSectionTitle.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: padding, left: padding, bottom: 4.0, right: padding), size: CGSize(width: view.frame.width, height: view.frame.height / 2.5))
        
        view.addSubview(exerciseHistoryTitle)
        exerciseHistoryTitle.anchor(top: chartCollectionView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: padding, left: padding, bottom: 4.0, right: padding))
        
        view.addSubview(exerciseHistoryCollectionView)
        exerciseHistoryCollectionView.anchor(top: exerciseHistoryTitle.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: padding, left: padding, bottom: padding * 2, right: padding))
    }
    
}
