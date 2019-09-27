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
        return ClientRepresentation(email: email, username: username, password: password, instructor: false, identifier: Int(identifier))
    }
    
    @discardableResult convenience init?(username: String, password: String, email: String, instructor: Bool = false, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.instructor = instructor
        self.username = username
        self.password = password
        self.email = email
    }
    
    @discardableResult convenience init?(clientRepresentation: ClientRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        guard let instructor = clientRepresentation.instructor,
            let username = clientRepresentation.username,
            let password = clientRepresentation.password,
            let email = clientRepresentation.email else {return nil}
        
        
        Client.init(username: username, password: password, email: email, instructor: instructor, context: context)
        
    }
    
}
