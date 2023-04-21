//
//  TodayStepsViewController.swift
//  Health_app_project
//
//  Created by student on 10/25/22.
//

import UIKit

class TodayStepsViewController: UIViewController {

    
    @IBOutlet weak var stepCount: UILabel!
    
    @IBAction func todayStepsProfileButton(_ sender: Any) {
        performSegue(withIdentifier: "seg_today_steps_profile", sender: sender)
    }
    
    var dataSteps : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepCount.text = dataSteps
    }
        
}
