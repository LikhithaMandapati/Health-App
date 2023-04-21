//
//  TodayHeartrateViewController.swift
//  Health_app_project
//
//  Created by student on 10/25/22.
//

import UIKit

class TodayHeartrateViewController: UIViewController {

    
    @IBAction func todayHeartRateProfileButton(_ sender: Any) {
        performSegue(withIdentifier: "seg_today_heartrate_profile", sender: sender)
    }
    @IBOutlet weak var heartRateLabel: UILabel!
    
    var dataHeartRate : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        heartRateLabel.text = dataHeartRate
       
    }
    

   

}
