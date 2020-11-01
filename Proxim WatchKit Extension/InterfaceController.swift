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

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var connectionLabel: WKInterfaceLabel!
    @IBOutlet var secondConnection: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
