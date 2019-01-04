//
//  FacialExercise.swift
//  Facial Exercises
//
//  Created by Samantha Gatt on 1/2/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import ARKit

protocol FacialExercise {
    
    typealias Coefficient = NSNumber
    
    var threshold: Float { get set }
    
    /// The name of the exercise to be displayed to the user
    var displayedTitle: String { get }
    /// The description and/or instructions on how to complete the exercise, to be displayed to the user
    var displayedDescription: String { get }
    
    /**
     Facial Expressions that make up the exercise
     - Author: Samantha Gatt
     */
    var expressions: [ARFaceAnchor.BlendShapeLocation] { get }
    
    /**
     Calculates the level of exaggeration of the facial exercise, taking into account each of the facial expressions it is comprised of
     - Author: Samantha Gatt
     - Parameter currentCoefficients: A dictionary containing each expression as a key and the user's current coefficient as the value
     - Returns: A float representing the percentage of success where 0 is no facial expressions present and 1 is all facial expressions fully present
     */
    func calculateProgress(currentCoefficients: [ARFaceAnchor.BlendShapeLocation : FacialExercise.Coefficient]) -> Float
    /**
     Should use the `calculateProgress` function
     - Author: Samantha Gatt
     - Parameter currentCoefficients: A dictionary containing each expression as a key and the user's current coefficient as the value
     - Returns: A boolean representing if the user has done the facial exercise sufficiently
     */
    func calculateSuccess(currentCoefficients: [ARFaceAnchor.BlendShapeLocation : FacialExercise.Coefficient]) -> Bool
}
