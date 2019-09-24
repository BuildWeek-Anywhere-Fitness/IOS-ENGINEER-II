//
//  ClassController.swift
//  AnywhereFitnessUnit2Build
//
//  Created by Taylor Lyles on 9/23/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import Foundation
import CoreData


class ClassController {
	
	// CUD
	
	// Create
	
	func createClass(with name: String, location: String, intesityLevel: String, duration: String, date: Date, category: String) {
		
		let classObject = Class(name: name,
						  category: Category(rawValue: category)!,
						  date: date,
						  duration: Duration(rawValue: duration)!,
						  intensityLevel: Intensity(rawValue: intesityLevel)!,
						  location: location)
		
		CoreDataStack.shared.save()
		
	}
	
	// UPDATE
	
	func updateClass(with classObject: Class, name: String, location: String, intesityLevel: String, duration: String, date: Date, category: String) {
		
		classObject.name = name
		classObject.location = location
		classObject.intensityLevel = intesityLevel
		classObject.duration = duration
		classObject.date = date
		classObject.category = category
		
		CoreDataStack.shared.save()
		
	}
	
	// DELETE
	
	func deleteClass(classObject: Class) {
		
		let context = CoreDataStack.shared.mainContext
		context.delete(classObject)
		
		CoreDataStack.shared.save()
		
	}
	
}
