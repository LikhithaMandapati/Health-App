//
//  HistoryViewController.swift
//  Health_app_project
//
//  Created by student on 10/24/22.
//

import UIKit
import FirebaseDatabase

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var ref: DatabaseReference!
    var history: [Vitals] = []
    var selectedIndex = 0
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // call the function to take data from fire base
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchDataFromFirebase()
    }
    
    // collect data from fire base
    func fetchDataFromFirebase() {
        ref = Database.database().reference().child("history")
        ref.getData(completion: { error, snapshot in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            
            //clearing the list
            self.history.removeAll()
            
            //iterating through all the values
            for vitals in snapshot?.children.allObjects as! [DataSnapshot] {
                //getting values
                let vitalsObj = vitals.value as? [String: AnyObject]
                let oxygen  = vitalsObj?["oxygen"] as! Int?
                let hr  = vitalsObj?["hr"] as! Int?
                let calories = vitalsObj?["calories"] as! Int?
                let steps = vitalsObj?["steps"] as! Int?
                let date = vitalsObj?["date"] as! String?
                
                //creating vitals object with model and fetched values
                let newVitals = Vitals(oxygen: oxygen, hr: hr, steps: steps, calories: calories, date: date)
                
                //appending it to list
                self.history.append(newVitals)
            }
            self.tableView.reloadData()
        })
    }
    

    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
   }
   
    // number of rows in table view
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return history.count
   }
    
    // height of row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
   
    // action to be performed when a row is selected
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath)
        //let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
        
        let dateLabel = cell.viewWithTag(5) as! UILabel
        dateLabel.text = history[indexPath.row].date
        cell.accessoryType = .disclosureIndicator
        return cell
        
    }
   
    // redirect controller from history to today tab
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       selectedIndex = indexPath.row
       performSegue(withIdentifier: "history_today", sender: self)
   }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "history_today" {
            let todayVC = segue.destination as! TodayViewController
            todayVC.todayHealthData = history[selectedIndex]
            todayVC.isFromHistory = true
        }
    }
   }
   
