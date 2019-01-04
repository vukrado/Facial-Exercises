//
//  ExerciseHistoryCollectionView.swift
//  Facial Exercises
//
//  Created by De MicheliStefano on 04.01.19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import UIKit

class ExerciseHistoryCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static private var cellId = "ExerciseHistoryCell"
    
    var exercises: [Exercise]? {
        didSet {
            reloadData()
        }
    }
    
    override init(frame: CGRect = CGRect.zero, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        delegate = self
        dataSource = self
        backgroundColor = UIColor.init(white: 0, alpha: 0.35)
        contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.init(white: 0, alpha: 0.6).cgColor
        layer.masksToBounds = true
        register(ExerciseHistoryCell.self, forCellWithReuseIdentifier: ExerciseHistoryCollectionView.cellId)
        self.allowsSelection = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exercises?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: ExerciseHistoryCollectionView.cellId, for: indexPath) as! ExerciseHistoryCell
        guard let exercises = exercises else { return cell }
        cell.exercise = exercises[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width - 24.0, height: 80)
    }
    
}

private class ExerciseHistoryCell: UICollectionViewCell {
    
    var exercise: Exercise? {
        didSet {
            updateViews()
        }
    }
    
    private let blurEffect: UIVisualEffectView = {
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        frost.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        frost.layer.cornerRadius = 8
        frost.layer.masksToBounds = true
        
        return frost
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    private let exerciseNameLabel: UILabel = {
        let label = UILabel()
        label.font = Appearance.appFont(style: .body, size: 17.0)
        label.numberOfLines = 1
        label.textColor = .white
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = Appearance.appFont(style: .body, size: 12.0)
        label.numberOfLines = 1
        label.textColor = .white
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = Appearance.appFont(style: .body, size: 12.0)
        label.numberOfLines = 1
        label.textColor = .white
        return label
    }()
    
    private let sidePadding: CGFloat = 12
    private let defaultBackgroundColor: UIColor = .clear
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = defaultBackgroundColor
        layer.cornerRadius = 8
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(blurEffect)
        blurEffect.fillSuperview()
        
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(exerciseNameLabel)
        mainStackView.addArrangedSubview(scoreLabel)
        mainStackView.addArrangedSubview(dateLabel)
        mainStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 8, left: sidePadding, bottom: 8, right: sidePadding))
    }
    
    private func updateViews() {
        guard let score = exercise?.score, let timestamp = exercise?.timestamp else { return }
        
        exerciseNameLabel.text = exercise?.type
        scoreLabel.text = "Score: \(String(describing: score))"
        dateLabel.text = "Date: \(String(describing: timestamp))"
    }
    
}
