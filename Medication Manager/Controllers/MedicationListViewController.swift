//
//  MedicationListViewController.swift
//  Medication Manager
//
//  Created by Emily Asch on 2/14/22.
//

import UIKit

class MedicationListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MedicationController.shared.fetchMedications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("clicking save now inside viewWill appear")
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
    }
    
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      //IIDOO
        //Identifier 
        if segue.identifier == "cellToMedicationDetails",
           let indexPath = tableView.indexPathForSelectedRow,
           let destination = segue.destination as? MedicationDetailViewController{
           let medication = MedicationController.shared.medications[indexPath.row]
            destination.medication = medication
        }
    }


}// end of class

extension MedicationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MedicationController.shared.medications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "medicationCell", for: indexPath) as? MedicationTableViewCell else {return UITableViewCell()}
        
        let medication = MedicationController.shared.medications[indexPath.row]
        
        cell.configure(with: medication)
    
        return cell
                
    }
    
    
}

extension MedicationListViewController: UITableViewDelegate{}
