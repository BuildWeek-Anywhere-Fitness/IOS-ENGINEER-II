//
//  TrainerClasses+Convenience.swift
//  AnywhereFitnessUnit2Build
//
//  Created by Alex Rhodes on 9/24/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import Foundation
import CoreData

extension TrainerClasses {
    
    @discardableResult convenience init?(name: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        
        self.init(context: context)
        
        self.name = name
        // classProperty does exist
    }
}
