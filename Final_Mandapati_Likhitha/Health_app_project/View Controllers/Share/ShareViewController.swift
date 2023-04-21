//
//  ShareViewController.swift
//  Health_app_project
//
//  Created by student on 10/24/22.
//

import UIKit
import MessageUI
import SpriteKit


class ShareViewController: UIViewController, MFMailComposeViewControllerDelegate {

    
    // profile button
    @IBAction func profileButton(_ sender: Any) {
        performSegue(withIdentifier: "seg_share_profile", sender: sender)
    }
    
    // share action
    @IBAction func shareBtnAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        let steps = defaults.integer(forKey: "steps")
        let calories = defaults.integer(forKey: "calories")
        let hr = defaults.integer(forKey: "hr")
        let oxygen = defaults.integer(forKey: "oxygen")
        let date = defaults.string(forKey: "date")
        
        // set up activity view controller
        let text = "Here are my health data: \n" + "Date: \(date ?? "N/A")\n" + "Calories: \(calories)\n" + "Steps: \(steps)\n" + "Heart rate: \(hr)\n" + "Oxygen Saturation: \(oxygen)\n"
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
}
