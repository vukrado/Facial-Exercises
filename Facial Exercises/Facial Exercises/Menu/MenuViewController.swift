//
//  ViewController.swift
//  Facial Exercises
//
//  Created by Simon Elhoej Steinmejer on 02/01/19.
//  Copyright © 2019 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "services").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        
        return button
    }()
    
    let statsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "combo_chart").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleStats), for: .touchUpInside)
        
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose which exercises you want to do"
        label.numberOfLines = 0
        label.font = Appearance.appFont(style: .title1, size: 24)
        label.textColor = .white
        label.textAlignment = .center
        label.sizeToFit()
        
        return label
    }()
    
    lazy var collectionView: ExerciseCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        
        let cv = ExerciseCollectionView(frame: .zero, collectionViewLayout: layout)
        cv.updateDelegate = self
        
        return cv
    }()
    
    let selectedExercisesLabel: UILabel = {
        let label = UILabel()
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
        view.setGradientBackground(colors: [UIColor.rgb(red: 166, green: 255, blue: 203).cgColor, UIColor.rgb(red: 18, green: 216, blue: 250).cgColor, UIColor.rgb(red: 31, green: 162, blue: 255).cgColor], locations: [0.0, 0.5, 1.0], startPoint: CGPoint(x: 1, y: 0), endPoint: CGPoint(x: 0, y: 1))
        
        setupViews()
    }
    
    @objc private func handleStart() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navVc = storyboard.instantiateViewController(withIdentifier: "Excercise") as! ExcerciseViewController
        self.present(navVc, animated: true, completion: nil)
    }
    
    @objc private func handleSettings() {
        print("Settings")
    }
    
    @objc private func handleStats() {
        print("Stats")
    }
    
    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [statsButton, settingsButton])
        stackView.spacing = 12
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 16), size: CGSize(width: 72, height: 30))
        
        view.addSubview(collectionView)
        collectionView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: CGSize(width: 0, height: 325))
        collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: collectionView.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 30, bottom: 30, right: 30))
        
        view.addSubview(selectedExercisesLabel)
        selectedExercisesLabel.anchor(top: collectionView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 12, left: 0, bottom: 0, right: 0))
        selectedExercisesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(startButton)
        startButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 30, bottom: 24, right: 30), size: CGSize(width: 0, height: 50))
    }
}

extension MenuViewController: ExerciseCollectionViewDelegate {
    func updateSelectedLabel(with amount: Int, max: Int) {
        selectedExercisesLabel.text = "\(amount)/\(max) exercises selected"
    }
}

