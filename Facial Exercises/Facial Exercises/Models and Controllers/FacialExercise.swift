//
//  FacialExercise.swift
//  Facial Exercises
//
//  Created by Samantha Gatt on 1/2/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import ARKit

protocol FacialExercise {
    
    /**
     A float from 0 to 1 at which a facial expression can be considered as complete
     - Author: Samantha Gatt
     */
    typealias SuccessThreshold = NSNumber
    
    /**
     Facial Expressions that make up the exercise and their respective success thresholds
     - Author: Samantha Gatt
     */
    var expressionsWithThresholds: [ARFaceAnchor.BlendShapeLocation : SuccessThreshold] { get }
    
    /**
     Calculates the level of exaggeration of the facial exercise, taking into account each of the facial expressions it is comprised of
     - Author: Samantha Gatt
     - Parameter currentCoefficients: A dictionary containing each expression as a key and the user's current coefficient as the value
     - Returns: A float representing the percentage of success where 0 is no facial expressions present and 1 is all facial expressions fully present
     */
    func calculateProgress(currentCoefficients: [ARFaceAnchor.BlendShapeLocation : ExerciseSession.Coefficient]) -> Float
    /**
     Should use the `calculateProgress` function
     - Author: Samantha Gatt
     - Parameter currentCoefficients: A dictionary containing each expression as a key and the user's current coefficient as the value
     - Returns: A boolean representing if the user has done the facial exercise sufficiently
     */
    func calculateSuccess(currentCoefficients: [ARFaceAnchor.BlendShapeLocation : ExerciseSession.Coefficient]) -> Bool
}

class EyebrowRaise: FacialExercise {
    
    var expressionsWithThresholds: [ARFaceAnchor.BlendShapeLocation : SuccessThreshold] {
        return [.browInnerUp: 1.0]
    }
    
    func calculateProgress(currentCoefficients: [ARFaceAnchor.BlendShapeLocation : ExerciseSession.Coefficient]) -> Float {
        
        if let expression = expressionsWithThresholds.first?.key,
            let threshold = expressionsWithThresholds.first?.value,
            let expressionThreshold = currentCoefficients[expression] {
            
            if expressionThreshold.floatValue >= threshold.floatValue {
                return 1.0
            } else {
                return expressionThreshold.floatValue / threshold.floatValue
            }
        } else {
            return 0.0
        }
    }
    
    func calculateSuccess(currentCoefficients: [ARFaceAnchor.BlendShapeLocation : ExerciseSession.Coefficient]) -> Bool {
        // If the user's facial expressions reach the thresholds of the exercise, it returns true
        return calculateProgress(currentCoefficients: currentCoefficients) == 1 ? true : false
    }
}

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
