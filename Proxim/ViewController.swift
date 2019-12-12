//
//  ViewController.swift
//  Proxim
//
//  Created by Addison Hanrattie on 12/12/19.
//  Copyright © 2019 Addison Hanrattie. All rights reserved.
//

import UIKit
import HealthKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let healthStore = HKHealthStore()
        healthStore.requestAuthorization(toShare: Set([HKWorkoutType.workoutType()]), read: Set([HKQuantityType.quantityType(forIdentifier: .heartRate)!, HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!, HKQuantityType.workoutType(), HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!, HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!])) { (succ, error) in
            if error != nil {
                print(error)
            } else if succ {
                print("Health Granted")
            }
        }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { (succ, error) in
            if error != nil {
                print(error)
            } else if succ {
                print("Notif Granted")
            }
        }
    }


}

