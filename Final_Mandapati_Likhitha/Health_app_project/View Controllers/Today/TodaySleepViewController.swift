//
//  TodaySleepViewController.swift
//  Health_app_project
//
//  Created by student on 10/25/22.
//

import UIKit

class TodaySleepViewController: UIViewController {

    @IBAction func todaySleepProfileButton(_ sender: Any) {
        performSegue(withIdentifier: "seg_today_sleep_profile", sender: sender)
    }
    @IBOutlet weak var bedTimeLabel: UILabel!
    @IBOutlet weak var wakeUpLabel: UILabel!
    @IBOutlet weak var alarmLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    

}
