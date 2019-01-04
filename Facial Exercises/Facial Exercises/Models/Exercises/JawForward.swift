//
//  JawForward.swift
//  Facial Exercises
//
//  Created by Samantha Gatt on 1/3/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import ARKit

class JawForward: FacialExercise {
    
    static var threshold: Float = 0.3
    
    var displayedTitle: String {
        return "Jaw Forwards"
    }
    var displayedDescription: String {
        return "Move your jaw forward for 5 seconds, then return it back to its resting position. Complete 5 repetitions."
    }
    
    var expressions: [ARFaceAnchor.BlendShapeLocation] = [.jawForward]
    
    func calculateProgress(currentCoefficients: [ARFaceAnchor.BlendShapeLocation : FacialExercise.Coefficient]) -> Float {
        
        guard let expression = expressions.first,
            let currentCoefficient = currentCoefficients[expression] else { return 0.0 }
            
        return currentCoefficient.floatValue / JawForward.threshold
    }
    
    func calculateSuccess(currentCoefficients: [ARFaceAnchor.BlendShapeLocation : FacialExercise.Coefficient]) -> Bool {
        return calculateProgress(currentCoefficients: currentCoefficients) >= 1 ? true : false
    }
}
