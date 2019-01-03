//
//  ViewController.swift
//  Facial Exercises
//
//  Created by Simon Elhoej Steinmejer on 02/01/19.
//  Copyright © 2019 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    let collectionView: ExerciseCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        
        let cv = ExerciseCollectionView(frame: .zero, collectionViewLayout: layout)
        
        return cv
    }()
    
    let selectedExercisesLabel: UILabel = {
        let label = UILabel()
        label.text = "1/5 Exercises selected"
        label.textColor = .black
        label.numberOfLines = 0
        label.font = Appearance.appFont(style: .body, size: 12)
        label.sizeToFit()
        label.textAlignment = .center
        
        return label
    }()
    
    let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start", for: .normal)
        button.backgroundColor = .selectedGreen
        button.titleLabel?.font = Appearance.appFont(style: .title2, size: 16)
        button.layer.cornerRadius = 8
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleStart), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
    }
    
    @objc private func handleStart() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navVc = storyboard.instantiateViewController(withIdentifier: "Excercise") as! ExcerciseViewController
        self.present(navVc, animated: true, completion: nil)
        print("Start")
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        collectionView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: CGSize(width: 0, height: 325))
        collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(selectedExercisesLabel)
        selectedExercisesLabel.anchor(top: collectionView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 12, left: 0, bottom: 0, right: 0))
        selectedExercisesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(startButton)
        startButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 30, bottom: 24, right: 30), size: CGSize(width: 0, height: 50))
    }
}

