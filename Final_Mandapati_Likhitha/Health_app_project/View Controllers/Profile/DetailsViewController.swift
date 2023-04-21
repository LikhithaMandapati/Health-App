//
//  DetailsViewController.swift
//  Health_app_project
//
//  Created by student on 10/25/22.
//

import UIKit
import FirebaseAuth

class DetailsViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // getting username and password details from login page
        let defaults = UserDefaults.standard
        let email = defaults.string(forKey: "email")
        let password = defaults.string(forKey: "password")
        
        // masking the password
        var dottedPassword = ""
        let count = password?.count ?? 0
        for _ in 0...count {
            dottedPassword += "*"
        }

        userNameLabel.text = email
        passwordLabel.text = dottedPassword
    }
    
    
    //log out action
    @IBAction func logOut(_ sender: Any) {
        do
        {
            try Auth.auth().signOut()
            let mainWindow = UIApplication
                .shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow }
            mainWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
    }
    

}
