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
     //  print("💊💊",request.description)
       return request
    }()

    var sections: [[Medication]] {[notTakenMeds, takenMeds]}
   private var notTakenMeds: [Medication] = []
    private var takenMeds: [Medication] = []
   
    
    //MARK: CRUD
    func create(name: String, timeOfDay: Date){
       let medication = Medication(name: name, timeOfDay: timeOfDay)
        notTakenMeds.append(medication)
        CoreDataStack.saveContext()
    }
    
    func fetchMedications(){
        let medications = (try? CoreDataStack.context.fetch(self.fetchRequest)) ?? []
        takenMeds = medications.filter{ $0.wasTakenToday() }
        notTakenMeds = medications.filter{ !$0.wasTakenToday() }
        //self.medications = medications
    }
    
    func updateMedication(medication: Medication, name: String, timeOfDay: Date){
        medication.name = name
        medication.timeOfDay = timeOfDay
        CoreDataStack.saveContext()
    }
    
    func markMedicationTaken(medication: Medication, wasTaken: Bool){
        if wasTaken{
            TakenDate(date: Date(), medication: medication)
            if let index = notTakenMeds.firstIndex(of: medication){
                notTakenMeds.remove(at: index)
                takenMeds.append(medication)
            }
           
        }else{
            //MARK: go over this at some point
            let mutableTakenDates = medication.mutableSetValue(forKey: "takenDates")
            if let takenDate = (mutableTakenDates as? Set<TakenDate>)?.first(where: {takenDate in
                guard let date = takenDate.date
                else {return false}
                
                return Calendar.current.isDate(date, inSameDayAs: Date())
            }){
                mutableTakenDates.remove(takenDate)
                if let index = takenMeds.firstIndex(of: medication){
                    takenMeds.remove(at: index)
                    notTakenMeds.append(medication)
                }
            }
        }
        CoreDataStack.saveContext()
        
    }// end of markMedicationTaken
    
    func deleteMedication(){
        
    }

}//end of class
