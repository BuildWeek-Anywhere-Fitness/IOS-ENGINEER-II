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

extension Class {
	
	@discardableResult convenience init?(name: String, category: Category, date: Date, duration: Duration, intensityLevel: Intensity, location: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		
		self.init(context: context)
		
		self.name = name
		self.category = category.rawValue
		self.date = date
		self.duration = duration.rawValue
		self.intensityLevel = intensityLevel.rawValue
		self.location = location
		
	}
	
	
	
}
