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
		
		enum CodingKeys: String, CodingKey {
			case name = "name"
            case location = "location"
            case duration = "duration"
            case category = "type"
            case intensityLevel = "intensity"
            case identifier = "instructor_id"
            case date = "starttime"
		}
	
}
