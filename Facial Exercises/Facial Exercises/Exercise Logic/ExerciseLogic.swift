//
//  ExerciseLogic.swift
//  Facial Exercises
//
//  Created by Simon Elhoej Steinmejer on 27/01/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import Foundation

protocol ExerciseLogicDelegate: class {
    func updateProgressBar(value: Float)
//    func update
}

class ExerciseLogic {
    
    
    init(exercises: [FacialExercise]) {
        self.exercises = exercises
    }
    
    ///timer for the 'exercise hold'
    private var timer: Timer?
    private var isPaused = false
    
    ///exercises to do
    var exercises: [FacialExercise]
    
    ///the highest reached
    private var highestResult: Float = 0.0
    
    ///which exercise the user is currently doing
    var exerciseCount: Int = 0
    
    
    func checkExpressionSuccess(expression: Float, exercise: FacialExercise) {
        //if experession is above threshold = let timer run
        //else pause timer
        if expression >= LevelHelper.getThreshold(for: exercises[exerciseCount].expressions.first!) {
            if isPaused {
                timer?.invalidate()
            }
        }
    }
    
    
    
}
