//
//  MedicationListViewController.swift
//  Medication Manager
//
//  Created by Emily Asch on 2/14/22.
//

import UIKit

class MedicationListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var moodSurveyButton: UIButton!
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MedicationController.shared.fetchMedications()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reminderFired),
                                               name: NSNotification.Name(Strings.medicationReminderReceived),
                                               object: nil)
        
        
        guard let survey = MoodSurveyController.shared.fetchSurveys() else {return}
        
        moodSurveyButton.setTitle(survey.mentalState, for: .normal)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("clicking save now inside viewWill appear")
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
//    @IBAction func addButtonTapped(_ sender: Any) {
//
//    }
    
    
    @IBAction func surveyButtonTapped(_ sender: Any) {
        print("survey tapped")
        guard let moodSurveyViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Strings.moodSurveyViewControllerIdentifier) as? MoodSurveyViewController else {return}
        
        
        moodSurveyViewController.delegate = self
        navigationController?.present(moodSurveyViewController, animated: true, completion: nil)
    }
    
 
    // MARK: - Navigation
    
   @objc private func reminderFired(){
       print("\(#file) received the memo!🛎")
       view.backgroundColor = .systemRed
       
       DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
           self.view.backgroundColor = nil
       }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      //IIDOO
        //Identifier 
        if segue.identifier == Strings.medicationDetailSegueIdenfitier,
           let indexPath = tableView.indexPathForSelectedRow,
           let destination = segue.destination as? MedicationDetailViewController{
            let medication = MedicationController.shared.sections[indexPath.section][indexPath.row]
            destination.medication = medication
        }
    }


}// end of class

extension MedicationListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MedicationController.shared.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MedicationController.shared.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "medicationCell", for: indexPath) as? MedicationTableViewCell else {return UITableViewCell()}
        
        let medication = MedicationController.shared.sections[indexPath.section][indexPath.row]
        
        cell.configure(with: medication)
        cell.delegate = self
        return cell
                
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Not Taken"
        }else if section == 1{
            return "Taken"
        }else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let medication = MedicationController.shared.sections[indexPath.section][indexPath.row]
            MedicationController.shared.deleteMedication(medication)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    
}//end of extension

extension MedicationListViewController: UITableViewDelegate{}

extension MedicationListViewController: MedicationTableViewCellDelegate{
  
    
    func medicationWasTakenButtonTapped(medication: Medication, wasTaken: Bool) {
      //  print("med was taken")
        MedicationController.shared.markMedicationTaken(medication: medication, wasTaken: wasTaken)
        tableView.reloadData()
    }
    
    
}// end of extension

extension MedicationListViewController: MoodSurveyControllerDelegate{
    func moodButtonTapped(with emoji: String) {
        MoodSurveyController.shared.didTapMoodEmoji(emoji)
        moodSurveyButton.setTitle(emoji, for: .normal)
    }
    
    
}
