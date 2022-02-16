//
//  MoodSurveyViewController.swift
//  Medication Manager
//
//  Created by Emily Asch on 2/15/22.
//

import UIKit

protocol MoodSurveyControllerDelegate: AnyObject{
    func moodButtonTapped(with emoji: String)
}

class MoodSurveyViewController: UIViewController {
    
    weak var delegate: MoodSurveyControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reminderFired),
                                               name: NSNotification.Name(Strings.medicationReminderReceived),
                                               object: nil)
    }

    @IBAction func emojiTapped(_ sender: UIButton) {
        print("emoji tapped")
        guard let emoji = sender.titleLabel?.text else {return}
        
        delegate?.moodButtonTapped(with: emoji)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func reminderFired(){
        print("\(#file) received the memo!🛎 in detail vc")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            self.view.backgroundColor = nil
        }
     }
    
}//end of class
