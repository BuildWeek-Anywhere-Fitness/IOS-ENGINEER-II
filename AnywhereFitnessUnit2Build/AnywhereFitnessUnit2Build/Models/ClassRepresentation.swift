//
//  ClassRepresentation.swift
//  AnywhereFitnessUnit2Build
//
//  Created by Alex Rhodes on 9/23/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import Foundation

struct ClassRepresentation: Equatable, Codable {
	let name: String
	let location: String
	let date: Date
	let duration: String
	let intesityLevel: String
	let category: String
	let attendees: String
	let identifier: Int
		
		enum CodingKeys: String, CodingKey {
			case name = ""
		}
	
}
