//
//  Class+Convenience.swift
//  AnywhereFitnessUnit2Build
//
//  Created by Alex Rhodes on 9/23/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import Foundation
import CoreData

enum Category: String, CaseIterable {
    case yoga
    case HIIT
    case powerLifting
    case crossFit
    case barre
    case cycling
    case dance
}

enum Duration: String, CaseIterable {
    case halfHour = "30 minutes"
    case hour = "60 minutes"
    case hourAndHalf = "90 minutes"
}

enum Intensity: String, CaseIterable {
    case beginner
    case intermediate
    case advanced
}

enum ClassType: String, CaseIterable {
    case clientClasses
    case trainerClasses
}

extension Class {
    
    var classRepresentation: ClassRepresentation? {
        return ClassRepresentation(name: name, location: location, date: date, duration: duration, intensityLevel: intensityLevel, category: category, identifier: Int(identifier), instructorID: Int(instructorID))
    }
    
    @discardableResult convenience init?(name: String, category: Category, date: Date, duration: Duration, intensityLevel: Intensity, location: String, classType: ClassType? = ClassType.trainerClasses, instructorID: Int = 1, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.instructorID = Int32(instructorID)
        self.name = name
        self.category = category.rawValue
        self.date = date
        self.duration = duration.rawValue
        self.intensityLevel = intensityLevel.rawValue
        self.location = location
        self.classType = classType?.rawValue
    }
    
    @discardableResult convenience init?(classRepresentation: ClassRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let name = classRepresentation.name,
            let category = classRepresentation.category,
            let date = classRepresentation.date,
            let duration = classRepresentation.duration,
            let intensityLevel = classRepresentation.intensityLevel,
            let location = classRepresentation.location,
            let instructorID = classRepresentation.instructorID
            else {return nil}
        
        self.init(name: name, category: Category(rawValue: category)!, date: date, duration: Duration(rawValue: duration)!, intensityLevel: Intensity(rawValue: intensityLevel)!, location: location, classType: nil, instructorID: instructorID, context: context)
    }
    
}
