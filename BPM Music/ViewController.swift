//
//  ViewController.swift
//  BPM Music
//
//  Created by Eric Bates on 8/25/18.
//  Copyright © 2018 Eric Bates. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    let healthStore = HKHealthStore()
    
    @IBAction func healthButton(_ sender: UIButton) {
        getHealthAuthorization()
    }
    private func getHealthAuthorization() {
        //Requests authorization to use health data found in healthkit
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        guard let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            fatalError("Unable to access heart rate")
        }
        guard let restingRate = HKObjectType.quantityType(forIdentifier: .restingHeartRate) else {
            fatalError("Unable to access resting heart rate")
        }
        let readingTypes: Set<HKObjectType> = [heartRate, restingRate]
        
        healthStore.requestAuthorization(toShare: nil, read: readingTypes) { (success, error) in
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:[NSObject: AnyObject]?) -> Bool {
        
        guard let heartType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return true
        }
        //this function enables background updates for heart rate data. Every time new heart rate data is sent to the device it sends data to the app as well.
        healthStore.enableBackgroundDelivery(for: heartType, frequency: .immediate) {
            success, error in
        }
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

