//
//  ExerciseController.swift
//  Facial Exercises
//
//  Created by Samantha Gatt on 1/9/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import ARKit

class ExerciseController {
    
    init(exercises: [FacialExercise]) {
        self.exercises = exercises
    }
    
    /// Represents the NSNumber that corresponds to a given expression's coefficient
    typealias Coefficient = NSNumber
    
    /// An array of all exercises to be managed
    let exercises: [FacialExercise]
    
    /**
     Calculates the level of exaggeration of the facial exercise, taking into account each of the facial expressions it is comprised of and returns a bool
     - Parameters:
     - exercise: The exercise in question
     - currentCoefficients: A dictionary containing each expression as a key and the user's current coefficient as the value
     - Returns: A bool representing if the exercise has been completed successfully by the user
     */
    func calculateSuccess(for exercise: FacialExercise, currentCoefficients: [ARFaceAnchor.BlendShapeLocation : Coefficient]) -> Bool {
        
        // Placeholder code until we figure out how it will work with more than one BlendShapeLocations (expressions)
        
        var individualProgress : [Float] = []
        
        for expression in exercise.expressions {
            if let currentCoefficient = currentCoefficients[expression] {
                individualProgress.append(currentCoefficient.floatValue / LevelHelper.getThreshold(for: expression))
            }
        }
        
        let progress = individualProgress.reduce(0.0, +) / Float(individualProgress.count)
        
        return progress >= 1 ? true : false
    }
}

