//
//  UserController.swift
//  AnywhereFitnessUnit2Build
//
//  Created by Taylor Lyles on 9/24/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import Foundation

enum NetworkError: Error {
	case encodingError
	case responseError
	case otherError
	case noData
	case noDecode
	case signUpError
}

enum HTTPMethod: String {
	case get = "GET"
	case put = "PUT"
	case post = "POST"
	case delete = "DELETE"
}

enum LoginType: String {
	case register
	case login
}

class UserController {
	
	var token: String?
	var client: ClientRepresentation?
	
	let baseURL = URL(string: "https://anywhere-health.herokuapp.com/api/users")!

	func clientSignUp(with client: ClientRepresentation, loginType: LoginType, completion: @escaping (NetworkError?) -> (Void)) {
		let signUpURL = baseURL.appendingPathComponent(loginType.rawValue)
		
		var request = URLRequest(url: signUpURL)
		request.httpMethod = HTTPMethod.post.rawValue

		
		do {
			request.httpBody = try JSONEncoder().encode(client)
			self.client = client
		} catch {
			NSLog("Error endoing user object: \(error)")
			completion(.encodingError)
			return
		}
		
		URLSession.shared.dataTask(with: request) { (_, response, error) in
			if let response = response as? HTTPURLResponse,
				response.statusCode != 200 {
				completion(.responseError)
				return
			}
			
			if let error = error {
				NSLog("Error signing client up: \(error)")
				completion(.signUpError)
				return
			}
			completion(nil)
		}.resume()
	}

	func clientLogIn(with client: ClientRepresentation, loginType: LoginType, completion: @escaping (Error?) -> ()) {
		let logInUrl = baseURL.appendingPathComponent(loginType.rawValue)
		
		var request = URLRequest(url: logInUrl)
		request.httpMethod = HTTPMethod.post.rawValue
		
		do {
			request.httpBody = try JSONEncoder().encode(client)
		} catch {
			NSLog("Error encoding client object: \(error)")
			completion(error)
			return
		}
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			
			if let response = response as? HTTPURLResponse,
				response.statusCode != 200 {
				completion(NSError())
				return
			}
			
			if let error = error {
				NSLog("Error logging in: \(error)")
				completion(error)
				return
			}
			
			guard let data = data else {
				completion(NSError(domain: "No data recieved", code: -1, userInfo: nil))
				return
			}
			
			do {
				let result = try JSONDecoder().decode(UserResult.self, from: data)
				self.token = result.token
				self.client = client
				let context = CoreDataStack.shared.mainContext
							   
							   context.performAndWait {
								   Client(clientRepresentation: self.client!)
							   }
							   
							   try CoreDataStack.shared.save(context: context)
							   if let token = self.token {
								   KeychainWrapper.standard.set(token, forKey: "token")
								   completion(.success(token))
							   }
			} catch {
				NSLog("Token not recieved: \(error)")
				completion(error)
				return
			}
		}
	}
}
