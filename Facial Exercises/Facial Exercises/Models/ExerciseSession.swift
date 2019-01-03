//
//  ExerciseSession.swift
//  Facial Exercises
//
//  Created by Samantha Gatt on 1/3/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import ARKit

class ExerciseSession {
    
    typealias Coefficient = NSNumber
    
    init(exercise: FacialExercise, successThreshold: Double, highestScore: Double = 0.0) {
        self.exercise = exercise
        self.highestScore = highestScore
        self.currentCoefficients = [:]
        
        for (expression, _) in exercise.expressionsWithThresholds {
            self.currentCoefficients[expression] = 0.0
        }
    }
    
    var exercise: FacialExercise
    var highestScore: Double
    var currentCoefficients: [ARFaceAnchor.BlendShapeLocation : Coefficient]
}
