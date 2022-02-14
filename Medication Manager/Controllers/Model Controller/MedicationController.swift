//
//  MedicationController.swift
//  Medication Manager
//
//  Created by Emily Asch on 2/14/22.
//

import CoreData

class MedicationController{
    // singleton
    static let shared = MedicationController()
    //can only be accessed in scope
    //MARK: why empty?
  private  init(){}
    
    //MARK: go over initialize and lazy
   private lazy var fetchRequest: NSFetchRequest<Medication> = {
       let request = NSFetchRequest<Medication>(entityName: "Medication")
       request.predicate = NSPredicate(value: true)
       return request
    }()
    
    var medications: [Medication] = []
    
    //MARK: CRUD
    func create(name: String, timeOfDay: Date){
       let medication = Medication(name: name, timeOfDay: timeOfDay)
        medications.append(medication)
        CoreDataStack.saveContext()
    }
    
    func fetchMedications(){
        let medications = (try? CoreDataStack.context.fetch(self.fetchRequest)) ?? []
        print("💊medications count", medications.count)
        self.medications = medications
    }
    
    func updateMedication(medication: Medication, name: String, timeOfDay: Date){
        medication.name = name
        medication.timeOfDay = timeOfDay
        CoreDataStack.saveContext()
    }
    
    func delete(){
        
    }
}
