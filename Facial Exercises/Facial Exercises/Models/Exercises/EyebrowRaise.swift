//
//  EyebrowRaise.swift
//  Facial Exercises
//
//  Created by Samantha Gatt on 1/3/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import ARKit

class EyebrowRaise: FacialExercise {
    
    static var threshold: Float = 0.3
    
    var displayedTitle: String {
        return "Eyebrow Raises"
    }
    var displayedDescription: String {
        return "Lift your eyebrows and hold for 10 seconds"
    }
    
    
    var expressions: [ARFaceAnchor.BlendShapeLocation] {
        return [.browInnerUp]
    }
    
    func calculateProgress(currentCoefficients: [ARFaceAnchor.BlendShapeLocation : FacialExercise.Coefficient]) -> Float {
        
        guard let expression = expressions.first,
            let currentCoefficient = currentCoefficients[expression] else { return 0.0 }
        
        return currentCoefficient.floatValue / EyebrowRaise.threshold
    }
    
    func calculateSuccess(currentCoefficients: [ARFaceAnchor.BlendShapeLocation : FacialExercise.Coefficient]) -> Bool {
        // If the user's facial expressions reach the thresholds of the exercise, it returns true
        return calculateProgress(currentCoefficients: currentCoefficients) == 1 ? true : false
    }
}
