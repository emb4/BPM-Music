//
//  MainView.swift
//  BPM Music
//
//  Created by Eric Bates on 8/25/18.
//  Copyright © 2018 Eric Bates. All rights reserved.
//

import Foundation
import UIKit
import HealthKit

class MainView: UIViewController {
    
    @IBOutlet weak var heartRateDisplay: UILabel!
    
    let healthStore = HKHealthStore()
    var anchor: HKQueryAnchor?
    
    func update(anchor value: HKQueryAnchor) -> HKQueryAnchor{
        return value
    }
    
    func updateHeartRate(completionHandler: @escaping () -> Void) {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {return}
        
        let anchoredQuery = HKAnchoredObjectQuery(type: heartRateType, predicate: nil, anchor: anchor, limit: Int(HKObjectQueryNoLimit)) { [unowned self] query, newSamples, deletedSamples, newAnchor, error -> Void in
            
            self.heartRateDisplay.text?.append("\(newSamples)")
            
            completionHandler()
        }
        healthStore.execute(anchoredQuery)
    }
    
    func heartRateUpdates(){
        guard  let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {return}
        
        let query = HKObserverQuery(sampleType: heartRateType, predicate: nil) {
            query, completionHandler, error in
            
            self.updateHeartRate() {
                completionHandler()
            }
        }
        
        healthStore.execute(query)
    }
}
