//
//  HistorySleepViewController.swift
//  Health_app_project
//
//  Created by student on 10/25/22.
//

import UIKit

class HistorySleepViewController: UIViewController {

    
    @IBAction func profileButton(_ sender: Any) {
        performSegue(withIdentifier: "seg_history_sleep_profile", sender: sender)
    }
    
    @IBOutlet weak var thisWeekSleepLabel: UILabel!
    @IBOutlet weak var lastWeekSleepLabel: UILabel!
    @IBOutlet weak var thisMonthSleepLabel: UILabel!
    @IBOutlet weak var lastMonthSleepLabel: UILabel!
    var dataSleep : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        thisWeekSleepLabel.text = "\(dataSleep) hours"
        lastWeekSleepLabel.text = String(Int.random(in: 5...9))
        thisMonthSleepLabel.text = String(Int.random(in: 5...9))
        lastMonthSleepLabel.text = String(Int.random(in: 5...9))
        
    }
    

    

}
