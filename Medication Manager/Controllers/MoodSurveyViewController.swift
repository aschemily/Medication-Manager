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

    @IBAction func emojiTapped(_ sender: UIButton) {
        print("emoji tapped")
        guard let emoji = sender.titleLabel?.text else {return}
        
        delegate?.moodButtonTapped(with: emoji)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}//end of class
