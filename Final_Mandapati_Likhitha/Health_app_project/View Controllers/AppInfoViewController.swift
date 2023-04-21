//
//  AppInfoViewController.swift
//  Health_app_project
//
//  Created by student on 10/29/22.
//

import UIKit

class AppInfoViewController: UIViewController {

    @IBOutlet var backgroundGradientView: UIView!
    
    @IBOutlet weak var titleLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(red: 255/255, green: 157/255, blue: 121/255, alpha: 1).cgColor, UIColor(red: 243/255, green: 109/255, blue: 101/255, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        backgroundGradientView.layer.addSublayer(gradientLayer)
    }
}
