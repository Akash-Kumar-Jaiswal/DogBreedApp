//
//  CoreDataManager.swift
//  DogBreedApp
//
//  Created by Apple on 10/07/24.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static let sharedManager = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DogBreedApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //MARK: - Save Data
    func saveContext () {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: - Insert Data
    func insertDog(name: String, breed : String, url: String, isFavourite: Bool)->Dogs? {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Dogs", in: managedContext)!
        let dog = NSManagedObject(entity: entity, insertInto: managedContext)
        
        dog.setValue(name, forKeyPath: "name")
        dog.setValue(breed, forKeyPath: "breed")
        dog.setValue(url, forKeyPath: "url")
        dog.setValue(isFavourite, forKeyPath: "isFavourite")
        
        do {
            try managedContext.save()
            return dog as? Dogs
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    //MARK: - Update Data
    func update(name:String, breed : String, url: String, isFavourite: Bool, dog : Dogs) {
        
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        do {
            dog.setValue(name, forKey: "name")
            dog.setValue(breed, forKey: "breed")
            dog.setValue(url, forKey: "url")
            dog.setValue(isFavourite, forKey: "isFavourite")
            
            print("\(String(describing: dog.value(forKey: "name")))")
            print("\(String(describing: dog.value(forKey: "breed")))")
            print("\(String(describing: dog.value(forKey: "url")))")
            print("\(String(describing: dog.value(forKey: "isFavourite")))")
            
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }
            
        }
    }
    
    //MARK: - Delete
    func delete(dog : Dogs){
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        do {
            managedContext.delete(dog)
        }
        do {
            try managedContext.save()
        } catch {
            print("Unable")
        }
    }
    
    //MARK: - Fetch All Data
    func fetchAllDogs() -> [Dogs]?{
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Dogs")
        
        do {
            let dog = try managedContext.fetch(fetchRequest)
            return dog as? [Dogs]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func delete(url: String) -> [Dogs]? {
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Dogs")
        
        fetchRequest.predicate = NSPredicate(format: "url == %@" ,url)
        do {
            
            let item = try managedContext.fetch(fetchRequest)
            var arrRemovedPeople = [Dogs]()
            for i in item {
                managedContext.delete(i)
                
                try managedContext.save()
                
                arrRemovedPeople.append(i as! Dogs)
            }
            return arrRemovedPeople
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
        
    }
}

