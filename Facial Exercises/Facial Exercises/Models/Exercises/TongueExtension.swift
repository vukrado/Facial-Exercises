//
//  TongueExtension.swift
//  Facial Exercises
//
//  Created by Samantha Gatt on 1/3/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import ARKit

class TongueExtension: FacialExercise {
    
    var threshold: Float = 0.3
    
    var displayedTitle: String {
        return "Tongue Extensions"
    }
    var displayedDescription: String {
        return "Stick your tongue out for 2 seconds. Complete 5 repetitions."
    }
    
    var expressions: [ARFaceAnchor.BlendShapeLocation] = [.tongueOut]
    
    func calculateProgress(currentCoefficients: [ARFaceAnchor.BlendShapeLocation : FacialExercise.Coefficient]) -> Float {
        
        guard let expression = expressions.first,
            let currentCoefficient = currentCoefficients[expression] else { return 0.0 }
        
        return currentCoefficient.floatValue / TongueExtension.threshold
    }
    
    func calculateSuccess(currentCoefficients: [ARFaceAnchor.BlendShapeLocation : FacialExercise.Coefficient]) -> Bool {
        return calculateProgress(currentCoefficients: currentCoefficients) >= 1 ? true : false
    }
}
