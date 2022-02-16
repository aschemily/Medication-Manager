//
//  MedicationController.swift
//  Medication Manager
//
//  Created by Emily Asch on 2/14/22.
//

import CoreData
import UserNotifications

class MedicationController{
    // singleton
    static let shared = MedicationController()
    let notificationScheduler = NotificationScheduler()
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
        
        //schedule notifications
        notificationScheduler.scheduleNotifications(for: medication)
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
        //clear notification
        notificationScheduler.cancelNotifications(for: medication)
        //add again with new time
        notificationScheduler.scheduleNotifications(for: medication)
        
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
    
    func markMedicationTaken(withID id: String){
        guard let medication = notTakenMeds.first(where: {$0.id == id})
        else {return }
        
        markMedicationTaken(medication: medication, wasTaken: true)
    }
    
            //MARK: question difference between for and _
    func deleteMedication(_ medication: Medication){
        if let index = notTakenMeds.firstIndex(of: medication){
            notTakenMeds.remove(at: index)
        }else if let index = takenMeds.firstIndex(of: medication){
            takenMeds.remove(at: index)
        }
        
        CoreDataStack.context.delete(medication)
        CoreDataStack.saveContext()
        notificationScheduler.cancelNotifications(for: medication)
       
        
    }

}//end of class
