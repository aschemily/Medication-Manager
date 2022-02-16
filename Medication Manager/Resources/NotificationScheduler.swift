//
//  NotificationScheduler.swift
//  Medication Manager
//
//  Created by Emily Asch on 2/16/22.
//

import Foundation
import UserNotifications

class NotificationScheduler{
    
    func scheduleNotifications(for medication: Medication){
        guard let id = medication.id, !id.isEmpty else {return}
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Time to take your \(medication.name ?? "")"
        content.sound = .default
        content.userInfo = [Strings.medicationID:id]
        content.categoryIdentifier = Strings.notificationCategoryIdefinitier
        
        let fireDateComponents = Calendar.current.dateComponents([.hour, .minute], from: medication.timeOfDay ?? Date())
      
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDateComponents, repeats: true)
      
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error{
                print("unable to schedule notifications🔕 \(error.localizedDescription)")
            }
        }
        
    }
    
    func cancelNotifications(for medication: Medication){
        //cancel notifications
        guard let id = medication.id else {return}
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    
    
    
}//end of class
