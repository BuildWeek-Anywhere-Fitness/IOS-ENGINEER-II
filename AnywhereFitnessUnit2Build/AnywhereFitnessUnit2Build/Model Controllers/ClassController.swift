//
//  ClassController.swift
//  AnywhereFitnessUnit2Build
//
//  Created by Taylor Lyles on 9/23/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import Foundation
import CoreData


class ClassController {
    
    var classObject: [ClassRepresentation]?
    
    var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy, h:mm a"
        formatter.timeZone = TimeZone(secondsFromGMT: secondsFromGMT)
        return formatter
    }
    
    let baseURL = URL(string: "https://anywhere-health.herokuapp.com/api/")!
    
    func preformSearch(with searchTerm: String, completion: @escaping (Result<[ClassRepresentation], NetworkError>) -> Void) {
        
        let requestURL = baseURL.appendingPathComponent("classes")
            .appendingPathComponent(searchTerm)
        
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        let token: String? = KeychainWrapper.standard.string(forKey: "token")
        
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // data task not ran yet
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // check to see that we can connect to the api for search, this is happeneing after the data task has run.
            if let error = error {
                NSLog("Error retrieving searched object: \(error)")
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                print(response.statusCode)
                completion(.failure(.responseError))
                return
            }
            
            //check to see if we recieved the results from the search
            guard let data = data else {
                NSLog("No data returned from search.")
                completion(.failure(.noData))
                return
            }
            
            // decode the data
            
            
            do {
                let decoder = JSONDecoder()
                let classObject = try decoder.decode([ClassRepresentation].self, from: data)
                self.classObject = classObject
                completion(.success(classObject))
                
            } catch {
                NSLog("Error retriving the results to your search: \(error)")
                completion(.failure(.noData))
                return
            }
            
            
        }.resume()
        
    }
    
    // POST classs to server
    func postClassOnServer(postClass: ClassRepresentation, completion: @escaping () -> Void = { }) {
        
        let requestURL: URL = baseURL.appendingPathComponent("classes")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            request.httpBody = try encoder.encode(postClass)
            completion()
            print("Succeeded posting")
        } catch {
            NSLog("Error encoding class \(postClass): \(error)")
            completion()
            return
        }
        
        //        URLSession.shared.dataTask(with: request) { (data, response, error) in
        //            if let error = error {
        //                NSLog("Error POSTing class to server: \(error)")
        //                completion()
        //                return
        //            }
        //
        //            guard let data = data else { return }
        //            do {
        //
        //                let classID = try JSONDecoder().decode([Int].self, from: data)
        //                let context = CoreDataStack.shared.mainContext
        //                context.performAndWait {
        //                    guard let name = postClass.name,
        //                        let category = postClass.category,
        //                        let date = postClass.date,
        //                        let duration = postClass.duration,
        //                        let intensity = postClass.intensityLevel,
        //                        let location = postClass.location,
        //                        let identifier = classID.first else { return }
        //                    Class(name: name, category: Category(rawValue: category)!, date: date, duration: Duration(rawValue: duration)!, intensityLevel: Intensity(rawValue: intensity)!, location: location, identifier: Int32(identifier))
        //                    
        //                }
        //
        //                CoreDataStack.shared.save(context: context)
        //            } catch {
        //                NSLog("Error decoding receipt and saving receipt: \(error)")
        //            }
        //
        //            completion()
        //        }.resume()
    }
    
    // update class on server
    func putClassOnServer(classRepresentation: ClassRepresentation, completion: @escaping () -> Void = { }) {
        
        guard let identifier = classRepresentation.identifier else { return }
        
        let requestURL: URL = baseURL.appendingPathComponent("class/\(identifier)")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        
        do {
            request.httpBody = try JSONEncoder().encode(classRepresentation)
        } catch {
            NSLog("Error encoding class \(classRepresentation): \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error PUTting class to server: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
    // adding class to server
    func put(classObject: Class, trainer: TrainerRepresentation, completion: @escaping () -> Void = { }) {
        
        let requestURL = baseURL
            .appendingPathComponent("classes")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        let token: String? = KeychainWrapper.standard.string(forKey: "token")
        
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        
        guard let classRepresentation = classObject.classRepresentation else {
            NSLog("Task Representation is nil")
            completion()
            return
        }
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(classRepresentation)
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
        } catch {
            NSLog("Error encoding task representation: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                print(response.statusCode)
                completion()
                return
            }
            
            if let error = error {
                NSLog("Error PUTting task: \(error)")
                completion()
                return
            }
            
            completion()
        }.resume()
    }
    
    func fetchAllClasses(completion: @escaping () -> Void = { }) {
        
        let requestURL = baseURL.appendingPathExtension("classes")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching class: \(error)")
                completion()
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion()
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                let classReprentations = try decoder.decode([ClassRepresentation].self, from: data)
                // trying to aassigning the returned array to CoreData all classes
                self.updateClassOnCoreData(with: classReprentations)
            } catch {
                NSLog("Error decoding: \(error)")
            }
            
        }.resume()
    }
    
    func deleteClassFromServer(classObject: Class, completion: @escaping (Error?) -> Void ) {
        
        let identifier = String(classObject.identifier)
        
        let requestURL = baseURL
            .appendingPathComponent("classes")
            .appendingPathComponent(identifier)
        
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error deleting class: \(error)")
                completion(error)
            }
        }.resume()
    }
    
    //
    func updateClassOnCoreData(with representations: [ClassRepresentation]) {
        
        let identifiersToFetch = representations.compactMap({ $0.identifier })
        
        // [UUID: TaskRepresentation]
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        // Make a mutable copy of the dictionary above
        var tasksToCreate = representationsByID
        
        let context = CoreDataStack.shared.backgroundContext
        
        context.performAndWait {
            
            do {
                
                
                let fetchRequest: NSFetchRequest<Class> = Class.fetchRequest()
                
                // identifier == \(identifier)
                fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
                
                // Which of these tasks exist in Core Data already?
                let existingTasks = try context.fetch(fetchRequest)
                
                // Which need to be updated? Which need to be put into Core Data?
                for classObject in existingTasks {
                    let identifier = Int(classObject.identifier)
                    // This gets the task representation that corresponds to the task from Core Data
                    guard let representation = representationsByID[identifier] else { continue }
                    
                    classObject.name = representation.name
                    classObject.category = representation.category
                    classObject.date = representation.date
                    classObject.duration = representation.duration
                    classObject.intensityLevel = representation.intensityLevel
                    
                    
                    tasksToCreate.removeValue(forKey: identifier)
                }
                
                // Take the tasks that AREN'T in Core Data and create new ones for them.
                for representation in tasksToCreate.values {
                    Class(classRepresentation: representation, context: context)
                }
                
                CoreDataStack.shared.save(context: context)
                
            } catch {
                NSLog("Error fetching tasks from persistent store: \(error)")
            }
        }
    }
    
    
    // Create
    
    func createClass(with name: String, location: String, intensityLevel: Intensity, duration: Duration , date: Date, category: Category, classType: ClassType?, trainer: TrainerRepresentation) {
        
        let classObject = Class(name: name, category: category, date: date, duration: duration, intensityLevel: intensityLevel, location: location, classType: classType)
        
        CoreDataStack.shared.save()
        put(classObject: classObject!, trainer: trainer)
    }
    
    // UPDATE
    
    func updateClass(with classObject: Class, name: String, location: String, intesityLevel: Intensity, duration: Duration, date: Date, category: Category, trainer: TrainerRepresentation) {
        
        classObject.name = name
        classObject.location = location
        classObject.intensityLevel = intesityLevel.rawValue
        classObject.duration = duration.rawValue
        classObject.date = date
        classObject.category = category.rawValue
        
        CoreDataStack.shared.save()
        self.put(classObject: classObject, trainer: trainer)
    }
    
    func updateClassType(with classObject: Class, classType: ClassType? = nil) {
        
        classObject.classType = classType?.rawValue
        
        CoreDataStack.shared.save()
        
    }
    
    // DELETE
    
    func deleteClass(classObject: Class) {
        
        let context = CoreDataStack.shared.mainContext
        context.delete(classObject)
        
        CoreDataStack.shared.save()
        
    }
}


