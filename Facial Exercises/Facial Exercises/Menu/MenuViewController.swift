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
        layout.minimumInteritemSpacing = 10
        
        let cv = ExerciseCollectionView(frame: .zero, collectionViewLayout: layout)
        
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
    }


}

