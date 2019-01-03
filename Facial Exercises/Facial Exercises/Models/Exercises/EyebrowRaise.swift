//
//  EyebrowRaise.swift
//  Facial Exercises
//
//  Created by Samantha Gatt on 1/3/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import ARKit

class EyebrowRaise: FacialExercise {
    
    var displayedTitle: String {
        return "Eyebrow Raises"
    }

    var displayedDescription: String {
        return "Lift your eyebrows and hold for 10 seconds"
    }
    
    var expressionsWithThresholds: [ARFaceAnchor.BlendShapeLocation : SuccessThreshold] {
        return [.browInnerUp: 1.0]
    }
    
    func calculateProgress(currentCoefficients: [ARFaceAnchor.BlendShapeLocation : ExerciseSession.Coefficient]) -> Float {
        
        guard let expression = expressionsWithThresholds.first?.key,
            let threshold = expressionsWithThresholds.first?.value,
            let currentCoefficient = currentCoefficients[expression] else { return 0.0 }
        
        return currentCoefficient.floatValue / threshold.floatValue
    }
    
    func calculateSuccess(currentCoefficients: [ARFaceAnchor.BlendShapeLocation : ExerciseSession.Coefficient]) -> Bool {
        // If the user's facial expressions reach the thresholds of the exercise, it returns true
        return calculateProgress(currentCoefficients: currentCoefficients) == 1 ? true : false
    }
}
