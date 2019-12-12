//
//  InterfaceController.swift
//  Proxim WatchKit Extension
//
//  Created by Addison Hanrattie on 12/12/19.
//  Copyright © 2019 Addison Hanrattie. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit

class InterfaceController: WKInterfaceController, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    let typesToShare: Set = [HKQuantityType.workoutType()]
    let typesToRead: Set = [HKQuantityType.quantityType(forIdentifier: .heartRate)!, HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!, HKQuantityType.workoutType(), HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!, HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!]
    let healthStore = HKHealthStore()
    
    var session : HKWorkoutSession!
    var builder : HKLiveWorkoutBuilder!
    
    @IBOutlet var connectionLabel: WKInterfaceLabel!
    @IBOutlet var secondConnection: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (succ, error) in
            if error != nil {
                print(error!)
            } else if succ {
                print("Health Granted")
            }
        }
        
        let config = HKWorkoutConfiguration()
        config.locationType = .indoor
        config.activityType = .other
//        config.swimmingLocationType = .openWater
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: config)
            builder = session.associatedWorkoutBuilder()
            session.delegate = self
            builder.delegate = self
            
            let dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: config)
            dataSource.disableCollection(for: HKQuantityType.quantityType(forIdentifier: .heartRate)!)
            dataSource.disableCollection(for: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!)
//            dataSource.disableCollection(for: HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!)
            print(dataSource.typesToCollect)
            builder.dataSource = dataSource
            
            session.startActivity(with: Date())
            builder.beginCollection(withStart: Date()) { (succ, error) in
                if error != nil {
                    print(error!)
                } else if succ {
                    print("Begun Collect")
                }
            }
        } catch {
            print(error)
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print(toState.rawValue)
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print(error)
    }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for sampType in collectedTypes {
            print(sampType)
//            print(WKExtension.shared().delegate as! ExtensionDelegate)
        }
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        print(workoutBuilder.workoutEvents)
    }
}
