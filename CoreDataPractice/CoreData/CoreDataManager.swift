//
//  CoreDataManager.swift
//  CoreDataPractice
//
//  Created by Aidos Mukatayev on 2022/04/21.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context = appDelegate?.persistentContainer.viewContext
    
    private init() { }
    
    // MARK: - Available methods
    func fetchPeople() -> [Person] {
        
        guard let context = context else { return [] }
        
        do {
            return try context.fetch(Person.fetchRequest())
        }
        catch {
            print("DEBUGGG: Error retrieving people from Persistent Container")
            return []
        }
    }
    
    func saveNewPerson(_ name: String, completion: ((SaveError?) -> Void)?) {
        guard let context = context else { return }
        let person = Person(context: context)
        person.name = name
        person.age = 10
        person.gender = "male"
        //Save data
        saveContext(context: context) { saveError in
            completion?(saveError)
        }
    }
    
    func deletePerson(_ person: Person, completion: ((DeleteError?) -> Void)?) {
        guard let context = context else { return }
        //Delete data
        deleteAndSaveContext(person: person, context: context) { deletionError in
            completion?(deletionError)
        }
    }
    
    func updatePerson(person: Person, completion: ((SaveError?) -> Void)?) {
        guard let context = context else { return }
        //Save data
        saveContext(context: context) { saveError in
            completion?(saveError)
        }
    }
    
    // MARK: - Private
    private func saveContext(context: NSManagedObjectContext, completion: ((SaveError?) -> Void)? = nil) {
        do {
            try context.save()
            completion?(nil)
        }
        catch {
            completion?(SaveError())
            print("Error while saving to context")
        }
    }
    
    private func deleteAndSaveContext(person: Person, context: NSManagedObjectContext, completion: ((DeleteError?) -> Void)? = nil) {
        do {
            context.delete(person)
            try context.save()
            completion?(nil)
        }
        catch {
            completion?(DeleteError())
            print("Error while deleting from context")
        }
    }
}
 

extension CoreDataManager {
    struct SaveError: Error {
        let description: String = "Error happened while saving to context"
    }
    
    struct DeleteError: Error {
        let description: String = "Error happened while deleting to context"
    }
}
