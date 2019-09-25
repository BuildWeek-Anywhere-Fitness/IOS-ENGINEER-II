//
//  ClientRepresentation.swift
//  AnywhereFitnessUnit2Build
//
//  Created by Alex Rhodes on 9/23/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import Foundation

struct ClientResult: Codable {
    var token: String
}

struct ClientRepresentation: Equatable, Codable {
	let email: String
	let username: String
	let password: String
}

