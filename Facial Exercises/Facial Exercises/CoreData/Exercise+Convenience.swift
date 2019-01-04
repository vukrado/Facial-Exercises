//
//  Exercise+Convenience.swift
//  Facial Exercises
//
//  Created by De MicheliStefano on 03.01.19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import Foundation
import CoreData

/**
 An exercise model which represents a facial exercise performed by the user.
 - Author: Stefano Demicheli
 */

extension Exercise {
    
    convenience init(type: String, identifier: UUID = UUID(), score: Float?, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.type = type
        self.score = score ?? 0.0
        self.timestamp = Date()
    }
    
}
