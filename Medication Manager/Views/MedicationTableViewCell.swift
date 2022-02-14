//
//  MedicationTableViewCell.swift
//  Medication Manager
//
//  Created by Emily Asch on 2/14/22.
//

import UIKit

class MedicationTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var wasTakenBtn: UIButton!
    
   
    @IBAction func wasTakenBtnTapped(_ sender: UIButton) {
        print("was taken button tapped")
    }
    
    
    func configure(with medication: Medication){
        nameLabel.text = medication.name
        timeLabel.text = DateFormatter.medicationTime.string(from: medication.timeOfDay ?? Date())
    }
    
    
    
}
