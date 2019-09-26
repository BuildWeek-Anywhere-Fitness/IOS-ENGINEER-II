//
//  TrainerRepresentatation.swift
//  AnywhereFitnessUnit2Build
//
//  Created by Alex Rhodes on 9/23/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import Foundation

struct TrainerResult: Codable {
    var token: String
}

struct TrainerRepresentation: Equatable, Codable {
    let email: String?
    let username: String?
    let password: String?
    let instructor: Bool?
    let identifier: Int?
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case username = "username"
        case password = "password"
        case instructor = "instructor"
        case identifier = "id"
    }
}


