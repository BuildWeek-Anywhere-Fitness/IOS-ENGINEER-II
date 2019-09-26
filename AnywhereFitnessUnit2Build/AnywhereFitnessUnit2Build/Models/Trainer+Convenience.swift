//
//  Trainer+Convenience.swift
//  AnywhereFitnessUnit2Build
//
//  Created by Taylor Lyles on 9/24/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import Foundation
import CoreData

extension Trainer {
	
	var trainerRepresentation: TrainerRepresentation?{
		guard let username = username,
			let password = password,
			let email = email else { return nil }
		return TrainerRepresentation(email: email, username: username, password: password)
    }
	
    @discardableResult convenience init?(username: String, password: String, email: String, identifier: Int32? = nil, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		
		self.init(context: context)
		
        self.identifier = identifier
		self.username = username
		self.password = password
		self.email = email
	}
	
	@discardableResult convenience init?(trainerRepresentation: TrainerRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.username = trainerRepresentation.username
        self.password = trainerRepresentation.password
        self.email = trainerRepresentation.email
    }
	
}
