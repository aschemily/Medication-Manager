//
//  Medication+convenience.swift
//  Medication Manager
//
//  Created by Emily Asch on 2/14/22.
//

import CoreData

extension Medication{
   @discardableResult convenience init(name: String, timeOfDay: Date, context: NSManagedObjectContext = CoreDataStack.context){
        self.init(context: context)
        self.name = name
        self.timeOfDay = timeOfDay
    }
    

}


