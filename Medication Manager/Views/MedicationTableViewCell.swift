//
//  MedicationTableViewCell.swift
//  Medication Manager
//
//  Created by Emily Asch on 2/14/22.
//

import UIKit

protocol MedicationTableViewCellDelegate: AnyObject{
    func medicationWasTakenButtonTapped(medication: Medication, wasTaken: Bool)
}

class MedicationTableViewCell: UITableViewCell {
    
    weak var delegate: MedicationTableViewCellDelegate?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var wasTakenBtn: UIButton!
    
    private var medication: Medication?
    private var wasTakenToday: Bool = false
    
    
    @IBAction func wasTakenBtnTapped(_ sender: UIButton) {
        print("was taken button tapped")
        guard let medication = medication else {return}
        
        wasTakenToday.toggle()
        delegate?.medicationWasTakenButtonTapped(medication: medication, wasTaken: wasTakenToday)
        
    }
    
    
    func configure(with medication: Medication){
        self.medication = medication
        wasTakenToday = medication.wasTakenToday()
        nameLabel.text = medication.name
        timeLabel.text = DateFormatter.medicationTime.string(from: medication.timeOfDay ?? Date())
        let image = wasTakenToday ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
        wasTakenBtn.setImage(image, for: .normal)
    }
    
    
    
}// end of class
