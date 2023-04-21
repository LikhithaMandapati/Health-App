//
//  ProfileTableTableViewController.swift
//  Health_app_project
//
//  Created by student on 10/25/22.
//

import UIKit

class ProfileTableTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var profileHealthData: Vitals?
    
    // close the view
    @IBAction func doneButton(_ sender: Any) {
        dismiss (animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    // number of sections in table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    // height of row in table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // action to be performed when a row is selected
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)

        let optionLabel = cell2.viewWithTag(9) as! UILabel
    
        //select personal details or about
        if indexPath.row == 0 {
            optionLabel.text = " PersonalDetails "
                
           // iconImage.image = todayHealthData.sleep.icon
            
        } else {
            optionLabel.text = " About "
        }
        
        //for indicator
        cell2.accessoryType = .disclosureIndicator

        return cell2
        
    }
    
    // directing the view controller using segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "seg_personalDetails", sender: self)
            
        } else {
            performSegue(withIdentifier: "seg_about", sender: self)
        }
    }


}
