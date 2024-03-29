//
//  ExtensionDelegate.swift
//  Proxim WatchKit Extension
//
//  Created by Addison Hanrattie on 12/12/19.
//  Copyright © 2019 Addison Hanrattie. All rights reserved.
//

import WatchKit
import WatchConnectivity
import UserNotifications

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate, UNUserNotificationCenterDelegate, WKExtendedRuntimeSessionDelegate {

    let notificationCenter = UNUserNotificationCenter.current()
    var extendedSession : WKExtendedRuntimeSession!
   
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if error != nil {
            print(error!)
        }
        print(activationState.rawValue, " state")
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("Is Reachable \(session.isReachable)")
        var noun = "error"
        if session.isReachable {
            noun = "connected"
        } else if !session.isReachable {
            noun = "lost"
        }
        (WKExtension.shared().rootInterfaceController as! InterfaceController).connectionLabel.setText("Connection: \(session.isReachable)")
        let content = UNMutableNotificationContent()
        content.title = "Connection Changed"
        content.body = "Connection: \(noun)"
        let request = UNNotificationRequest(identifier: "Change", content: content, trigger: nil)
        notificationCenter.add(request) { (error) in
            if error != nil {
                print("Notif Error")
                print(error!)
            } else {
                print("queued")
            }
        }
    }
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { (succ, error) in
            if error != nil {
                print(error!)
            } else if succ {
                print("Notif Granted")
            }
        }
        
        WCSession.default.delegate = self
        guard WCSession.isSupported() else {
            fatalError("requires watch connectivity")
        }
        WCSession.default.activate()
        print("uni")
        notificationCenter.delegate = self
        extendedSession = WKExtendedRuntimeSession()
        extendedSession.delegate = self
        extendedSession.start()
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                // Be sure to complete the relevant-shortcut task once you're done.
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                // Be sure to complete the intent-did-run task once you're done.
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("will present")
        completionHandler(.alert)
    }
    
    // MARK: - Extended Sessions
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        print(reason)
        if error != nil {
            print(error!)
        }
    }
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("Now using time")
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("About to expire transfer to a real workout")
    }
}
