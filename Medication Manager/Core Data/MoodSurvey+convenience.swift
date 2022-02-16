//
//  MoodSurvey+convenience.swift
//  Medication Manager
//
//  Created by Emily Asch on 2/15/22.
//

import CoreData

extension MoodSurvey{
    @discardableResult convenience init(mentalState: String, date: Date, context: NSManagedObjectContext = CoreDataStack.context){
        self.init(context: context)
        self.mentalState = mentalState
        self.date = date
    }
}
