//
//  LevelHelper.swift
//  Facial Exercises
//
//  Created by Samantha Gatt on 1/3/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import ARKit

enum LevelHelper {
    
    static func updateLevel() {
        
    }
    
    static func getThreshold(for expression: ARFaceAnchor.BlendShapeLocation) -> Float {
        return 0.6
    }
}
