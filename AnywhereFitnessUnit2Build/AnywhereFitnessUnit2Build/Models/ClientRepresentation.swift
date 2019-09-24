//
//  ClientRepresentation.swift
//  AnywhereFitnessUnit2Build
//
//  Created by Alex Rhodes on 9/23/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import Foundation

struct ClientRepresentation: Equatable, Codable {
	let username: String
	let password: String
	let email: String
}


struct UserResult: Codable {
    var token: String
}
