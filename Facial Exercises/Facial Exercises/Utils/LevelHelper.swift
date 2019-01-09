//
//  LevelHelper.swift
//  Facial Exercises
//
//  Created by Samantha Gatt on 1/3/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import ARKit

enum LevelHelper {
    
    enum Level: Int {
        case easy
        case medium
        case hard
    }

    private static let levelKey = "levelKey"
    
    public static func updateLevelPreference(_ level: LevelHelper.Level) {
        UserDefaults.standard.set(level.rawValue, forKey: LevelHelper.levelKey)
    }
    
    public static func getLevelPreference() -> LevelHelper.Level {
        switch UserDefaults.standard.integer(forKey: levelKey) {
        case 1:
            return .medium
        case 2:
            return .hard
        default:
            return .easy
        }
    }
    
    public static func getThreshold(for expression: ARFaceAnchor.BlendShapeLocation) -> Float {
        switch getLevelPreference() {
        case .easy:
            return 0.25
        case .medium:
            return 0.40
        case .hard:
            return 0.55            
        }
    }
}
