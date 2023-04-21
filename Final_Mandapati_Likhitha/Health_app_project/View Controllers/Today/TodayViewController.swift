//
//  TodayViewController.swift
//  Health_app_project
//
//  Created by student on 10/25/22.
//

import UIKit
import FirebaseDatabase
import HealthKit

class TodayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var dataOxygen : Int?
    var dataCalories : Int?
    var dataHeartRate : Int?
    var dataSteps : Int?
    var refreshDate = ""
    var todayHealthData: Vitals?
    var isFromHistory = false
    var ref: DatabaseReference!
    let healthStore = HKHealthStore()
    var timer = Timer()
    private var heartRateVariability = HKUnit(from: "count/min")
    
    @IBOutlet weak var dateLabel: UILabel!
     
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var btnRefresh: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKit()
        
        // present this when it is requested from history tab
        if isFromHistory {
            self.tableView.reloadData()
            self.dateLabel.text = self.todayHealthData?.date
            btnUpload.isHidden = true
            btnRefresh.isHidden = true
        }
        // present this if it is from today tab
        else {
            fetchHealthData()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy hh:mm:ss"
            dateLabel.text = formatter.string(from: Date())
            btnUpload.isHidden = false
            btnRefresh.isHidden = false
        }
    }
    
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "latestHeartRate" with the interval of 5 seconds
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.latestHeartRate), userInfo: nil, repeats: true)

    }
    
    // update UI when refresh is clicked
    func updateUI() {
        self.todayHealthData = Vitals(oxygen: self.dataOxygen, hr: self.dataHeartRate, steps: self.dataSteps, calories: self.dataCalories, date: self.refreshDate)
        self.tableView.reloadData()
        self.dateLabel.text = self.todayHealthData?.date
        
        let defaults = UserDefaults.standard
        defaults.set(self.todayHealthData?.steps, forKey: "steps")
        defaults.set(self.todayHealthData?.calories, forKey: "calories")
        defaults.set(self.todayHealthData?.oxygen, forKey: "oxygen")
        defaults.set(self.todayHealthData?.hr, forKey: "hr")
        defaults.set(self.todayHealthData?.date, forKey: "date")
    }
    
    // function to collect data about steps, oxygen saturation, calories burnt and heart rate from watch
    func fetchHealthData() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy hh:mm:ss"
        self.refreshDate = formatter.string(from: Date())
        self.latestHeartRate()
        self.latestStepCount()
        self.latestCalories()
        self.latestOxygenSaturation()
        self.latestHRV()
        self.scheduledTimerWithTimeInterval()
    }
    
    // calling func to upload data to fire base
    @IBAction func btnUploadAction(_ sender: Any) {
        uploadTodayVitalsToFirebase()
    }
    
    // function to upload data to firebase
    func uploadTodayVitalsToFirebase() {
        // sending data to history tab
        ref = Database.database().reference().child("history")
        let refChild = ref.childByAutoId()
        let dic = NSMutableDictionary()
        dic .setValue(self.todayHealthData?.calories, forKey: "calories")
        dic .setValue(self.todayHealthData?.hr, forKey: "hr")
        dic .setValue(self.todayHealthData?.steps, forKey: "steps")
        dic .setValue(self.todayHealthData?.oxygen, forKey: "hrv")
        dic .setValue(self.todayHealthData?.date, forKey: "date")
        
        refChild.updateChildValues(dic as [NSObject : AnyObject]) { (error, ref) in
            if(error != nil){
                print("Firebase upload error: " + error.debugDescription)
            }else{
                // display alert
                let alert = UIAlertController(title: "Upload Success", message: "The health data is uploaded to Firebase successfully!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    //height of row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    //action when a row is selecetd
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)

        
        let optionLabel = cell1.viewWithTag(1) as! UILabel
        let iconImage = cell1.viewWithTag(2) as! UIImageView
        let dataLabel = cell1.viewWithTag(3) as! UILabel
        
    
        // oxygen
        if indexPath.row == 1 {
            optionLabel.text = "HRV"
            iconImage.image = UIImage(named: "heart rate")
            dataLabel.text = String(todayHealthData?.oxygen ?? 0) + " ms"
        }
        // steps
        else if indexPath.row == 0 {
            optionLabel.text = "Steps"
            iconImage.image = UIImage(named: "steps")
            dataLabel.text = String(todayHealthData?.steps ?? 0) + " steps"
        }
        //calories
        else if indexPath.row == 2 {
            optionLabel.text = "Calories"
            iconImage.image = UIImage(named: "calories")
            dataLabel.text = String(todayHealthData?.calories ?? 0) + " kcal"
        }
        // heart rate
        else {
            optionLabel.text = "Heart Rate"
            iconImage.image = UIImage(named: "heart rate")
            dataLabel.text = String(todayHealthData?.hr ?? 0) + " bpm"
        }

        return cell1
    }
    
    // authorization
    func authorizeHealthKit(){
        let writableTypes: Set<HKSampleType> = [
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.oxygenSaturation)!,
                HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
                HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!,
                HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
                HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRateVariabilitySDNN)!
            ]
            let readableTypes: Set<HKSampleType> = [
                HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.oxygenSaturation)!,
                HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
                HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!,
                HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
                HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRateVariabilitySDNN)!
            ]
       healthStore.requestAuthorization(toShare: writableTypes, read: readableTypes) { (chk, error) in
            if (chk) {
                print("permission granted")
            }
        }
        
    }
    
    // collect heart rate from watch
    @objc func latestHeartRate() {
        
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { (sample, result, error) in
            guard error == nil else{
                return
            }
            let data = result![0] as! HKQuantitySample
            let unit = HKUnit(from: "count/min")
            let latestHr = data.quantity.doubleValue(for: unit)
            self.dataHeartRate = Int(latestHr)
            //print("\(latestHr)")
            
            DispatchQueue.main.async() {
                self.updateUI()
            }
        }
        healthStore.execute(query)
        
        
        /*guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else { return }
            
           let workoutStartDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
            let datePredicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: Date(), options: .strictEndDate )
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate])
            
            let heartRateQuery = HKAnchoredObjectQuery(type: quantityType, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, sampleObjects, deleteObjects, newAnchor, error) -> Void in
                self.updateHeartRate(sampleObjects)
            }
            
            heartRateQuery.updateHandler = {(query, samples, deleteObjects, newAnchor, error) -> Void in
                self.updateHeartRate(samples)
            }
            healthStore.execute(heartRateQuery)*/
    }
    
    func updateHeartRate(_ samples: [HKSample]?) {
             guard let heartRateSamples = samples as? [HKQuantitySample] else {return}
           for sample in heartRateSamples {
             let timeStamp = sample.startDate
             let value = sample.quantity
             print("\(timeStamp)_\(value)")
         }
    }
    
    
    //collect step count from watch
    func latestStepCount() {
        
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let datepredicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now,
            options: .strictStartDate
        )
        
        let watchPredicate = HKQuery.predicateForObjects(withDeviceProperty: HKDevicePropertyKeyModel, allowedValues: ["Watch"])
        
        let query = HKStatisticsQuery(
            quantityType: stepsQuantityType,
            quantitySamplePredicate: NSCompoundPredicate(type: .and, subpredicates: [datepredicate, watchPredicate]),
            options: .cumulativeSum
        ) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                return
            }
            let steps = sum.doubleValue(for: HKUnit.count())
            self.dataSteps = Int(steps)
            
            DispatchQueue.main.async() {
                self.updateUI()
            }
        }
        healthStore.execute(query)
    }
    
    
    // collect calories burnt from watch
    func latestCalories() {
        let calories = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
            
            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            let predicate = HKQuery.predicateForSamples(
                withStart: startOfDay,
                end: now,
                options: .strictStartDate
            )
            
            let query = HKStatisticsQuery(
                quantityType: calories,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, _ in
                guard let result = result, let sum = result.sumQuantity() else {
                    return
                }
                let calories = sum.doubleValue(for: HKUnit.kilocalorie())
                self.dataCalories = Int(calories)
                
                DispatchQueue.main.async() {
                    self.updateUI()
                }
            }
        healthStore.execute(query)
    }
    
    
    // collect oxygen from watch
    func latestOxygenSaturation() {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else {
            return
        }
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { (sample, result, error) in
            guard error == nil else{
                return
            }
            let data = result![0] as! HKQuantitySample
            let unit = HKUnit(from: "ms")
            let latestOxygenSat = data.quantity.doubleValue(for: unit)
            self.dataOxygen = Int(round(latestOxygenSat))
            
            DispatchQueue.main.async() {
                self.updateUI()
            }
        }
        healthStore.execute(query)
    }
    
    // collect oxygen from watch
    func latestHRV() {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else {
            return
        }
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { (sample, result, error) in
            guard error == nil else{
                return
            }
            let data = result as! [HKQuantitySample]
            for d in data {
                let unit = HKUnit(from: "ms")
                let value = d.quantity.doubleValue(for: unit)
                let date = d.startDate
                print("HRV value: \(value), Date: \(date)")
            }
            print(data)
            //let latestHRV = data.quantity.doubleValue(for: unit)
            
            DispatchQueue.main.async() {
                //print("HRV value: \(value), Date: \(date)")
            }
        }
        healthStore.execute(query)
    }
    
    
    //refresh button
    @IBAction func refresh(_ sender: Any) {
        fetchHealthData()
    }

}
