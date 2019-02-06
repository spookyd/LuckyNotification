//
//  ViewController.swift
//  LuckyNotification
//
//  Created by Luke Davis on 1/26/19.
//  Copyright © 2019 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit
import LuckyNotification

class ViewController: UIViewController {
    
    let notification: LuckyNotification = LuckyNotification()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func handleShowMessage(_ sender: Any) {
        notification.showNotification(icon: #imageLiteral(resourceName: "errorIcon"), title: "Test", description: "Sorry, you've been invited to an accepted group at Stanford University. Upload your acceptance letter to gain access.")
    }
    
    @IBAction func handleShowLocalNotification(_ sender: Any) {
        var notification = Notification(message: NSAttributedString(string: "Sorry, you've been invited to an accepted group at Stanford University. Upload your acceptance letter to gain access."))
        notification.icon = #imageLiteral(resourceName: "errorIcon")
        var config = NotificationConfiguration.default
        config.minimumHeight = 400
        let provider = LuckyNotification()
        provider.configuration = config
        provider.showNotification(notification)
    }
    
    private var transitionManager = NotificationTransitionManager()
    @IBAction func handleAction(_ sender: Any) {
        let string = NSAttributedString(string: "Testing the attributed string functionality", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        let notificationMessage = Notification(icon: #imageLiteral(resourceName: "errorIcon"), message: string)
        self.notification.scheduleNotification(notificationMessage, inSeconds: 2, notificationType: .general)
    }
    
}

