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
        notification.showNotification(icon: #imageLiteral(resourceName: "errorIcon"), title: "Test", description: "Some test description")
    }
    
    @IBAction func handleShowLocalNotification(_ sender: Any) {
        let alert = UIAlertController(title: "tes", message: "asdf", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            
        }))
        self.present(alert, animated: true) {
            self.notification.showNotification(icon: #imageLiteral(resourceName: "errorIcon"), title: "asdf", description: "asdfasdfasdf")
        }
//        let content = UNMutableNotificationContent()
//        content.title = "10 Second Notification Demo"
//        content.subtitle = "From MakeAppPie.com"
//        content.body = "Notification after 10 seconds - Your pizza is Ready!!"
//        content.categoryIdentifier = "message"
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
//        let request = UNNotificationRequest(identifier: "com.lucky13", content: content, trigger: trigger)
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: .none)
    }
    
    private var transitionManager = NotificationTransitionManager()
    @IBAction func handleAction(_ sender: Any) {
//        let notification = NotificationViewController()
//        notification.notificationView.titleLabel.text = "Test Looking"
//        notification.notificationView.descriptionLabel.text = "The text to be shown"
//        self.present(notification, animated: true, completion: .none)
//        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
//            self?.notification.showNotification(icon: .none, title: "asdfasdf", description: "asdfsadfsadf sdfasdfasdf")
////            self?.dismiss(animated: true, completion: .none)
//        }
    }
    
}

