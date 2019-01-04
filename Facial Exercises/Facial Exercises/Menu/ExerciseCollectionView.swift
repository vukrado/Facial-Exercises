//
//  ExerciseCollectionView.swift
//  Facial Exercises
//
//  Created by Simon Elhoej Steinmejer on 02/01/19.
//  Copyright © 2019 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

protocol ExerciseCollectionViewDelegate: class {
    func updateSelectedLabel(with amount: Int, max: Int)
}

class ExerciseCollectionView: UICollectionView {
    
    let exercises: [FacialExercise] = [.eyebrowRaises, .tongueExtensions, .jawForwards, .eyeWinks]
    
    weak var updateDelegate: ExerciseCollectionViewDelegate?
    private var cellId = "ExerciseCell"
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        delegate = self
        dataSource = self
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        register(ExerciseCell.self, forCellWithReuseIdentifier: cellId)
        allowsSelection = true
        allowsMultipleSelection = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExerciseCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateDelegate?.updateSelectedLabel(with: self.indexPathsForSelectedItems?.count ?? 0, max: exercises.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateDelegate?.updateSelectedLabel(with: self.indexPathsForSelectedItems?.count ?? 0, max: exercises.count)
    }
}

extension ExerciseCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        updateDelegate?.updateSelectedLabel(with: 0, max: exercises.count)
        return exercises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ExerciseCell
        
        let exercise = exercises[indexPath.item]
        cell.exerciseLabel.text = exercise.title
        cell.exerciseDescriptionLabel.text = exercise.description
        
        return cell
    }
}

extension ExerciseCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width - 70, height: self.frame.height)
    }
}
