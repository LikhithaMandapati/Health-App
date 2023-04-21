//
//  LoginViewController.swift
//  Health_app_project
//
//  Created by student on 10/28/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    
    //information about the app
    @IBAction func infoButton(_ sender: Any) {
        performSegue(withIdentifier: "seg_login_appInfo", sender: sender)
    }
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    // user sign in
    @IBAction func singIn(_ sender: Any) {
        Auth.auth().signIn(withEmail: username.text ?? "", password: password.text ?? "") { [weak self] authResult, error in
            
            if let user = authResult?.user {
                print(user)
                guard let strongSelf = self else {
                    return
                }
                let defaults = UserDefaults.standard
                defaults.set(self?.username.text, forKey: "email")
                defaults.set(self?.password.text, forKey: "password")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
                vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                strongSelf.password.text = ""
                strongSelf.present(vc, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Login Error", message: "The entered account is invalid, please try again!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
          
        }
    }
    
    // keyboard should close when return key in keyboard is clicked
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
