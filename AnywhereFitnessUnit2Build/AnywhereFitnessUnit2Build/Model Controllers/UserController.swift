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
    case noToken
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
    
    var id: Int?
    var token: String?
    var client: ClientRepresentation?
    var trainer: TrainerRepresentation?
    
    let baseURL = URL(string: "https://anywhere-health.herokuapp.com/api/users")!
    
    func clientSignUp(with client: ClientRepresentation, loginType: LoginType, completion: @escaping (Result<String, NetworkError>) -> (Void)) {
        
        let signUpURL = baseURL.appendingPathComponent(loginType.rawValue)
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(client)
            self.client = client
        } catch {
            NSLog("Error endoing user object: \(error)")
            completion(.failure(.encodingError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                completion(.failure(.responseError))
                return
            }
            
            if let error = error {
                NSLog("Error signing client up: \(error)")
                completion(.failure(.signUpError))
                return
            }
            completion(.success("login successful"))
        }.resume()
    }
    
    func clientLogIn(with client: ClientRepresentation, loginType: LoginType, completion: @escaping (Result<String, NetworkError>) -> ()) {
        let logInUrl = baseURL.appendingPathComponent(loginType.rawValue)
        
        var request = URLRequest(url: logInUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        do {
            request.httpBody = try JSONEncoder().encode(client)
        } catch {
            NSLog("Error encoding client object: \(error)")
            completion(.failure(.encodingError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                print(response.statusCode)
                completion(.failure(.responseError))
                return
            }
            
            if let error = error {
                NSLog("Error logging in: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(ClientResult.self, from: data)
                self.token = result.token
                self.client = client
                let context = CoreDataStack.shared.mainContext
                
                context.performAndWait {
                    Client(clientRepresentation: self.client!)
                }
                
                try CoreDataStack.shared.save(context: context)
                if let token = self.token {
                    KeychainWrapper.standard.set(token, forKey: "token")
                    completion(.success("setting keychain wrapper"))
                }
            } catch {
                NSLog("Token not recieved: \(error)")
                completion(.failure(.noToken))
                return
            }
        }.resume()
    }
    
    func trainerSignUp(with trainer: TrainerRepresentation, loginType: LoginType, completion: @escaping (Result<String, NetworkError>) -> (Void)) {
        let signUpURL = baseURL.appendingPathComponent(loginType.rawValue)
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(trainer)
            self.trainer = trainer
        } catch {
            NSLog("Error endoing user object: \(error)")
            completion(.failure(.encodingError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                completion(.failure(.responseError))
                return
            }
            
            if let error = error {
                NSLog("Error signing client up: \(error)")
                completion(.failure(.signUpError))
                return
            }
            
            guard let data = data else {return}
            
            let decoder = JSONDecoder()
            
            do {
                let trainer = try decoder.decode(TrainerRepresentation.self, from: data)
                self.trainer = trainer
                // Take the trainerrep above and initialize a Trainer
                
                // Save the context
            } catch {
                NSLog("error decoding trianer: \(error)")
            }
            
            
            completion(.success("login successful"))
        }.resume()
    }
    
    func trainerLogIn(with trainer: TrainerRepresentation, loginType: LoginType, completion: @escaping (Result<String, NetworkError>) -> ()) {
        
        let logInUrl = baseURL.appendingPathComponent(loginType.rawValue)
        
        var request = URLRequest(url: logInUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        do {
            request.httpBody = try JSONEncoder().encode(trainer)
        } catch {
            NSLog("Error encoding client object: \(error)")
            completion(.failure(.encodingError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                print(response.statusCode)
                completion(.failure(.responseError))
                return
            }
            
            if let error = error {
                NSLog("Error logging in: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(TrainerResult.self, from: data)
                self.trainer = trainer
                self.token = result.token
                
                let context = CoreDataStack.shared.mainContext
                
                context.performAndWait {
                    Trainer(trainerRepresentation: trainer)
                }
                
                try CoreDataStack.shared.save(context: context)
                if let token = self.token {
                    KeychainWrapper.standard.set(token, forKey: "token")
                    completion(.success("setting keychain wrapper"))
                }
            } catch {
                NSLog("Token not recieved: \(error)")
                completion(.failure(.noToken))
                return
            }
            completion(.success("Successful Login"))
        }.resume()
    }
}
