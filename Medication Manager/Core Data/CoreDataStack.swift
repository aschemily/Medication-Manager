//
//  CoreDataStack.swift
//  Medication Manager
//
//  Created by Emily Asch on 2/14/22.
//

import CoreData

enum CoreDataStack{
    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Medication_Manager")
        container.loadPersistentStores {storeDescription, error in
            if let error = error {
                fatalError("❌Error loading persistent stores\(error)")
            }
        }
        return container
    }()
    
    static var context: NSManagedObjectContext {container.viewContext}
    
    static func saveContext(){
        if context.hasChanges{
            do{
                try context.save()
            }catch{
                NSLog("🔥error saving context \(error)")
            }
        }
    }
    
}//end of core data stack enum

