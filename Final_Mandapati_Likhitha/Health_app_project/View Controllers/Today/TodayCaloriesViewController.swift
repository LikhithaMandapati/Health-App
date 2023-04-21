//
//  TodayCaloriesViewController.swift
//  Health_app_project
//
//  Created by student on 10/25/22.
//

import UIKit

class TodayCaloriesViewController: UIViewController {

    @IBAction func todayCaloriesProfileButton(_ sender: Any) {
        performSegue(withIdentifier: "seg_today_calories_profile", sender: sender)
    }
    @IBOutlet weak var caloriesLabel: UILabel!
    
    var dataCalories : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        caloriesLabel.text = dataCalories
        
    }
    

   
}
