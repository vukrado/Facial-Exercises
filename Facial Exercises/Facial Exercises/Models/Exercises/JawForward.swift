//
//  JawForward.swift
//  Facial Exercises
//
//  Created by Samantha Gatt on 1/3/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import ARKit

class JawForward: FacialExercise {
    
    static var displayedTitle: String {
        return "Jaw Forwards"
    }
    static var displayedDescription: String {
        return "Move your jaw forward for 5 seconds, then return it back to its resting position. Complete 5 repetitions."
    }
    
    var expressionsWithThresholds: [ARFaceAnchor.BlendShapeLocation : SuccessThreshold] = [.jawForward : 1.0]
    
    func calculateProgress(currentCoefficients: [ARFaceAnchor.BlendShapeLocation : ExerciseSession.Coefficient]) -> Float {
        
        guard let expression = expressionsWithThresholds.first?.key,
            let threshold = expressionsWithThresholds.first?.value,
            let currentCoefficient = currentCoefficients[expression] else { return 0.0 }
            
        return currentCoefficient.floatValue / threshold.floatValue
    }
    
    func calculateSuccess(currentCoefficients: [ARFaceAnchor.BlendShapeLocation : ExerciseSession.Coefficient]) -> Bool {
        return calculateProgress(currentCoefficients: currentCoefficients) == 1 ? true : false
    }
}
