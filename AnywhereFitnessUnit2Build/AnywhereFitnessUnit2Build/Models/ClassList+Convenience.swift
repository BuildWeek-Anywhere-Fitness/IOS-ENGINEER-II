//
//  ClassList+Convenience.swift
//  AnywhereFitnessUnit2Build
//
//  Created by Alex Rhodes on 9/24/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import Foundation
import CoreData

extension ClassList {
    
    static let shared = ClassList()
    
    var allClasses: ClassList? {
        
         let list = ClassList(name: "allClasses")
        
        return  list
    }
    
    var trainerClasses: ClassList? {
           
            let list = ClassList(name: "trainerClasses")
           
           return  list
       }
    
    var clientClasses: ClassList? {
        
         let list = ClassList(name: "clientClasses")
        
        return  list
    }
    
    @discardableResult convenience init?(name: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.name = name
    }
}
