//
//  FacialExercise.swift
//  Facial Exercises
//
//  Created by Samantha Gatt on 1/2/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import ARKit

class FacialExercise {
    
    init(title: String, description: String, expressions: [ARFaceAnchor.BlendShapeLocation], holdCount: Float, repeatCount: Int) {
        self.title = title
        self.description = description
        self.expressions = expressions
        self.holdCount = holdCount
        self.repeatCount = repeatCount
    }
    
    /// The name of the exercise to be displayed to the user
    var title: String
    
    /// The description and/or instructions on how to complete the exercise, to be displayed to the user
    var description: String
    
    /// Facial Expressions that make up the exercise
    var expressions: [ARFaceAnchor.BlendShapeLocation]
    
    var holdCount: Float
    
    var repeatCount: Int
    
    
    /// The shared instance of the eyebrow raises exercise
    static let eyebrowRaises = FacialExercise(title: "Eyebrow Raises", description: "Lift your eyebrows and hold for 10 seconds", expressions: [.browInnerUp], holdCount: 5.0, repeatCount: 2)
   
    /// The shared instance of the eyebrow raises exercise
    static let tongueExtensions = FacialExercise(title: "Tongue Extensions", description: "Stick your tongue out for 2 seconds. Complete 5 repetitions.", expressions: [.tongueOut], holdCount: 2.0, repeatCount: 2)
    
    /// The shared instance of the eyebrow raises exercise
    static let jawForwards = FacialExercise(title: "Jaw Forwards", description: "Move your jaw forward for 5 seconds, then return it back to its resting position. Complete 5 repetitions.", expressions: [.jawForward], holdCount: 5.0, repeatCount: 5)
    
    /// The shared instance of the eyebrow raises exercise
    static let eyeWinks = FacialExercise(title: "Eye Winks", description: "Close both eyes for 3 seconds. Then alternate eyelids 4 times.", expressions: [.eyeBlinkLeft, .eyeBlinkRight], holdCount: 2.0, repeatCount: 10)
}

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
