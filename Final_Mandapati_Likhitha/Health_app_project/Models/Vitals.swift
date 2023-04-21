//
//  Vitals.swift
//  Health_app_project
//
//  Created by Nikhil Varma on 25/11/2022.
//

import Foundation

class Vitals {
    
    var oxygen: Int?
    var hr: Int?
    var steps: Int?
    var calories: Int?
    var date: String?
    
    init(oxygen: Int?, hr: Int?, steps: Int?, calories: Int?, date: String?){
        self.oxygen = oxygen
        self.hr = hr
        self.steps = steps
        self.calories = calories
        self.date = date
    }
}
