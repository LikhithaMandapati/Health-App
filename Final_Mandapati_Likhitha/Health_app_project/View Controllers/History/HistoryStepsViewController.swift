//
//  HistoryStepsViewController.swift
//  Health_app_project
//
//  Created by student on 10/25/22.
//

import UIKit

class HistoryStepsViewController: UIViewController {

    
    @IBAction func historyStepsProfileButton(_ sender: Any) {
        performSegue(withIdentifier: "seg_history_steps_profile", sender: sender)
    }
    
    @IBOutlet weak var thisWeekStepsLabel: UILabel!
    @IBOutlet weak var lastWeekStepsLabel: UILabel!
    @IBOutlet weak var thismonthStepsLabel: UILabel!
    @IBOutlet weak var lastMonthStepsLabel: UILabel!
    var dataSteps : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        thisWeekStepsLabel.text = dataSteps
        lastWeekStepsLabel.text = String(Int.random(in: 15000...20000))
        thismonthStepsLabel.text = String(Int.random(in: 150000...200000))
        lastMonthStepsLabel.text = String(Int.random(in: 150000...200000))
        
    }
    

   

}
