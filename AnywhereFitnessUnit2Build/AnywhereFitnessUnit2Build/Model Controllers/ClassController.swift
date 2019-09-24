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
    
    let baseURL = URL(string: "https://anywhere-health.herokuapp.com/api/")!
    
    // POST classs to server
    func postClass(postClass: ClassRepresentation, completion: @escaping () -> Void = { }) {
        let requestURL: URL = baseURL.appendingPathComponent("classes")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            request.httpBody = try encoder.encode(postClass)
        } catch {
            NSLog("Error encoding class \(postClass): \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error POSTing class to server: \(error)")
                completion()
                return
            }
            
            guard let data = data else { return }
            do {
                
                let classID = try JSONDecoder().decode([Int].self, from: data)
                let moc = CoreDataStack.shared.mainContext
                moc.performAndWait {
                    guard let name = postClass.name,
                        let category = postClass.category,
                        let date = postClass.date,
                        let duration = postClass.duration,
                        let intensity = postClass.intensityLevel,
                        let location = postClass.location,
                        let identifier = classID.first else { return }
                    Class(name: name, category: Category(rawValue: category)!, date: date, duration: Duration(rawValue: duration)!, intensityLevel: Intensity(rawValue: intensity)!, location: location, identifier: Int32(identifier))                }
                
                CoreDataStack.shared.save(context: moc)
            } catch {
                NSLog("Error decoding receipt and saving receipt: \(error)")
            }
            
            completion()
        }.resume()
    }
    
    // update class on server
    func putClass(classRepresentation: ClassRepresentation, completion: @escaping () -> Void = { }) {
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
                
                let classReprentations = try decoder.decode([String: ClassRepresentation].self, from: data).map({ $0.value })
                
                self.updateClassOnCoreData(with: classReprentations)
            } catch {
                NSLog("Error decoding: \(error)")
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
       
    
    // Create
    
    func createClass(with name: String, location: String, intensityLevel: String, duration: String, date: Date, category: String, identifier: Int?) {
        
        let classObject = ClassRepresentation(name: name, location: location, date: date, duration: duration, intensityLevel: intensityLevel, category: category, identifier: nil)
        
        CoreDataStack.shared.save()
        putClass(classRepresentation: classObject)
        
    }
    
    // UPDATE
    
    func updateClass(with classObject: Class, name: String, location: String, intesityLevel: String, duration: String, date: Date, category: String) {
        
        classObject.name = name
        classObject.location = location
        classObject.intensityLevel = intesityLevel
        classObject.duration = duration
        classObject.date = date
        classObject.category = category
        
        CoreDataStack.shared.save()
        
    }
    
    // DELETE
    
    func deleteClass(classObject: Class) {
        
        let context = CoreDataStack.shared.mainContext
        context.delete(classObject)
        
        CoreDataStack.shared.save()
        
    }
}

