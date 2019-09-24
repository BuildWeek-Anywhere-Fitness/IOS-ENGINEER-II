//
//  Client+Convenience.swift
//  AnywhereFitnessUnit2Build
//
//  Created by Taylor Lyles on 9/24/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import Foundation
import CoreData

extension Client {
	
	var clientRepresentation: ClientRepresentation?{
		guard let username = username,
			let password = password,
			let email = email else { return nil }
        return ClientRepresentation(username: username, password: password, email: email)
    }
	
	@discardableResult convenience init?(username: String, password: String, email: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		
		self.init(context: context)
		
		self.username = username
		self.password = password
		self.email = email
	}
	
	@discardableResult convenience init?(clientRepresentation: ClientRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.username = clientRepresentation.username
        self.password = clientRepresentation.password
        self.email = clientRepresentation.email
    }
	
}
