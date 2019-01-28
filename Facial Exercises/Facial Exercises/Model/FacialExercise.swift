//
//  FacialExercise.swift
//  Facial Exercises
//
//  Created by Samantha Gatt on 1/2/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import ARKit

class FacialExercise {
    
    init(title: String, description: String, expression: ARFaceAnchor.BlendShapeLocation, holdCount: Float, repeatCount: Int) {
        self.title = title
        self.description = description
        self.expression = expression
        self.holdCount = holdCount
        self.repeatCount = repeatCount
    }
    
    /// The name of the exercise to be displayed to the user
    var title: String
    
    /// The description and/or instructions on how to complete the exercise, to be displayed to the user
    var description: String
    
    /// Facial Expressions that make up the exercise
    var expression: ARFaceAnchor.BlendShapeLocation
    
    var holdCount: Float
    
    var repeatCount: Int
    
    
    /// The shared instance of the eyebrow raises exercise
    static let eyebrowRaises = FacialExercise(title: "Eyebrow Raises", description: "Lift your eyebrows", expression: .browInnerUp, holdCount: 5.0, repeatCount: 1)
   
    /// The shared instance of the eyebrow raises exercise
    static let tongueExtensions = FacialExercise(title: "Tongue Extensions", description: "Stick your tongue out", expression: .tongueOut, holdCount: 2.0, repeatCount: 1)
    
    /// The shared instance of the eyebrow raises exercise
    static let jawForwards = FacialExercise(title: "Jaw Forwards", description: "Move your jaw forward", expression: .jawForward, holdCount: 5.0, repeatCount: 1)
    
    /// The shared instance of the eyebrow raises exercise
    static let eyeBlinkLeft = FacialExercise(title: "Eye Blink Left", description: "Blink left eye", expression: .eyeBlinkRight, holdCount: 1.0, repeatCount: 1)
    
    static let eyeBlinkRight = FacialExercise(title: "Eye Blink Right", description: "Blink right eye", expression: .eyeBlinkLeft, holdCount: 1.0, repeatCount: 1)
}
