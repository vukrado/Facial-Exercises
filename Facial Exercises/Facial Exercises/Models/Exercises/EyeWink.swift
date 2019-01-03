//
//  EyeWink.swift
//  Facial Exercises
//
//  Created by Samantha Gatt on 1/3/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import ARKit

class EyeWink: FacialExercise {
    
    static var displayedTitle: String {
        return "Eye Winks"
    }
    static var displayedDescription: String {
        return "Close both eyes for 3 seconds. Then alternate eyelids 4 times."
    }
    
    var expressionsWithThresholds: [ARFaceAnchor.BlendShapeLocation : SuccessThreshold] = [.eyeBlinkLeft : 1.0, .eyeBlinkRight : 1.0]
    
    func calculateProgress(currentCoefficients: [ARFaceAnchor.BlendShapeLocation : ExerciseSession.Coefficient]) -> Float {
        
        var individualProgress : [Float] = []
        
        for (expression, threshold) in expressionsWithThresholds {
            
            if let currentCoefficient = currentCoefficients[expression] {
                
                if currentCoefficient.floatValue >= threshold.floatValue {
                    individualProgress.append(1.0)
                } else {
                    individualProgress.append(currentCoefficient.floatValue / threshold.floatValue)
                }
            }
        }
        return individualProgress.reduce(0.0, +) / Float(individualProgress.count)
    }
    
    func calculateSuccess(currentCoefficients: [ARFaceAnchor.BlendShapeLocation : ExerciseSession.Coefficient]) -> Bool {
        return calculateProgress(currentCoefficients: currentCoefficients) == 1 ? true : false
    }
}
