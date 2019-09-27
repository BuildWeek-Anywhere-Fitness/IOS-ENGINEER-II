//
//  ClassRepresentation.swift
//  AnywhereFitnessUnit2Build
//
//  Created by Alex Rhodes on 9/23/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import Foundation

struct ClassRepresentation: Codable {
    
	let name: String?
	let location: String?
	let date: Date?
	let duration: String?
	let intensityLevel: String?
	let category: String?
	let identifier: Int?
    let instructorID: Int?
    let maxSize: Int = 20
		
		enum CodingKeys: String, CodingKey {
			case name = "name"
            case location = "location"
            case duration = "duration"
            case category = "type"
            case intensityLevel = "intensity"
            case identifier = "id"
            case date = "starttime"
            case instructorID = "instructor_id"
            case maxSize = "max_size"
		}
	
}
