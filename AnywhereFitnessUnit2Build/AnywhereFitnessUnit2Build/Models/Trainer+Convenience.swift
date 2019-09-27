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
        return TrainerRepresentation(email: email, username: username, password: password, instructor: true, identifier: Int(identifier))
    }
    
    @discardableResult convenience init?(username: String, password: String, email: String, instructor: Bool = true, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.instructor = instructor
        self.identifier = Int32(identifier)
        self.username = username
        self.password = password
        self.email = email
    }
    
    @discardableResult convenience init?(trainerRepresentation: TrainerRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        guard let instructor = trainerRepresentation.instructor,
        let username = trainerRepresentation.username,
        let password = trainerRepresentation.password,
            let email = trainerRepresentation.email else {return}
        
        Trainer.init(username: username, password: password, email: email, instructor: instructor, context: context)
    }
}
