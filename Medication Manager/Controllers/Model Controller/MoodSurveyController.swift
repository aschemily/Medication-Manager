//
//  MoodSurveyController.swift
//  Medication Manager
//
//  Created by Emily Asch on 2/15/22.
//

import CoreData

class MoodSurveyController {
    
    var todaysMoodSurvey: MoodSurvey?
    
    //instance
    static let shared = MoodSurveyController()
    
    private init(){}
    
    //MARK: go over initialize and lazy
  private lazy var fetchRequest: NSFetchRequest<MoodSurvey> = {
       let request = NSFetchRequest<MoodSurvey>(entityName: "MoodSurvey")
      let startOfToday = Calendar.current.startOfDay(for: Date())
      let endOfToday = Calendar.current.date(byAdding: .day, value: 1, to: startOfToday) ?? Date()
      let afterPredicate = NSPredicate(format: "date > %@", startOfToday as NSDate)
      let beforePredicate = NSPredicate(format: "date < %@", endOfToday as NSDate)
      
      request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [afterPredicate, beforePredicate])
       return request
    }()
    
    //CRU
    private func createMoodSurvey(mentalState: String){
        let moodSurvey = MoodSurvey(mentalState: mentalState, date: Date())
        
        todaysMoodSurvey = moodSurvey
        CoreDataStack.saveContext()
    }
    
    func fetchSurveys() -> MoodSurvey?{
        guard let todaysMoodSurvey = try? CoreDataStack.context.fetch(fetchRequest).first else {return nil}
        self.todaysMoodSurvey = todaysMoodSurvey
        return todaysMoodSurvey
    }
    
    private func update(newMentalState: String){
        guard let todaysMoodSurvey = todaysMoodSurvey else {return}
        
        todaysMoodSurvey.mentalState = newMentalState
        CoreDataStack.saveContext()
    }
    
    func didTapMoodEmoji(_ emoji: String){
        if todaysMoodSurvey != nil {
            update(newMentalState: emoji)
        }else{
            createMoodSurvey(mentalState: emoji)
        }
    }
    
    
    
    
}//end of class
