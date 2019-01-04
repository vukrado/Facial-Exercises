//
//  EyeWink.swift
//  Facial Exercises
//
//  Created by Samantha Gatt on 1/3/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import ARKit

class EyeWink: FacialExercise {
    
    var threshold: Float = 0.3
    
    var displayedTitle: String {
        return "Eye Winks"
    }

    var displayedDescription: String {
        return "Close both eyes for 3 seconds. Then alternate eyelids 4 times."
    }
    
    var expressions: [ARFaceAnchor.BlendShapeLocation] = [.eyeBlinkLeft, .eyeBlinkRight]
    
    func calculateProgress(currentCoefficients: [ARFaceAnchor.BlendShapeLocation : FacialExercise.Coefficient]) -> Float {
        
        var individualProgress : [Float] = []
        
        for expression in expressions {
            if let currentCoefficient = currentCoefficients[expression] {
                individualProgress.append(currentCoefficient.floatValue / EyeWink.threshold)
            }
        }
        
        return individualProgress.reduce(0.0, +) / Float(individualProgress.count)
    }
    
    func calculateSuccess(currentCoefficients: [ARFaceAnchor.BlendShapeLocation : FacialExercise.Coefficient]) -> Bool {
        return calculateProgress(currentCoefficients: currentCoefficients) >= 1 ? true : false
    }
}
