//
//  LuckyNotification.swift
//  LuckyNotification
//
//  Created by Luke Davis on 1/27/19.
//  Copyright © 2019 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

public class LuckyNotification {

    public enum NotificationType {
        case importantEscalation
        case general

        static var all: [NotificationType] = [
            .importantEscalation,
            .general
        ]
    }

    private static let shared: LuckyNotification = LuckyNotification()

    public var configuration: NotificationConfiguration = .default {
        didSet {
            // Update Notification
            self.notificationViewController.view.layer.cornerRadius = configuration.cornerRadius
            if #available(iOS 11.0, *) {
                self.notificationViewController.notificationView.directionalLayoutMargins = configuration.layoutMargin.toNSDirectionalEdgeInsets()
            } else {
                self.notificationViewController.notificationView.layoutMargins = configuration.layoutMargin.toUIEdgeInsets()
            }
            self.notificationViewController.notificationView.iconSize = configuration.iconSize
            self.notificationViewController.notificationView.spacing = configuration.contentSpacing
            self.notificationViewController.notificationView.titleLabel.font = configuration.titleFont
            self.notificationViewController.notificationView.titleLabel.textColor = configuration.titleColor
            self.notificationViewController.notificationView.descriptionLabel.font = configuration.descriptionFont
            self.notificationViewController.notificationView.descriptionLabel.textColor = configuration.descriptionColor
            self.transitionManager.updateConfiguration(configuration)
        }
    }

    /// Seconds before the timer notification should dismiss. Adjust if the app needs longer transient messages.
    public var displayDuration: TimeInterval = 6

    // Timer for dismissing notifications.
    private var messageHideTimer: Timer?

    private var timers: [NotificationType: Timer] = [:]

    var applicationTopMostViewController: UIViewController {
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            fatalError("Could not locate the application's current view controller")
        }
        var topMostViewController = rootViewController
        while let nextTopMostVC = topMostViewController.presentedViewController {
            topMostViewController = nextTopMostVC
        }
        return topMostViewController
    }

    private var transitionManager: NotificationTransitioningDelegate

    // MARK: - Display Configuration

    lazy var notificationViewController: NotificationViewController = {
        let notification = NotificationViewController()
        notification.modalPresentationStyle = .custom
        notification.transitioningDelegate = self.transitionManager
        return notification
    }()

    public init() {
        let transitionManager = NotificationTransitionManager()
        self.transitionManager = transitionManager
    }

    public init(customTransitionDelegate: NotificationTransitioningDelegate) {
        self.transitionManager = customTransitionDelegate
    }

    // MARK: - Notification Handling

    public func showNotification(icon: UIImage?, title: String?, description: String?, autoHide: Bool = true) {
        self.showNotification(Notification(icon: icon, title: title, description: description), autoHide: autoHide)
    }

    public func showNotification(_ notification: Notification, autoHide: Bool = true) {
        messageHideTimer?.invalidate()
        if autoHide {
            messageHideTimer = Timer.scheduledTimer(withTimeInterval: displayDuration, repeats: false, block: { [weak self] _ in
                self?.dismissNotification(true)
            })
        }
        self.notificationViewController.notificationView.image = notification.icon
        self.notificationViewController.notificationView.titleLabel.text = notification.title
        self.notificationViewController.notificationView.descriptionLabel.text = notification.description
        if let message = notification.message {
            self.notificationViewController.notificationView.descriptionLabel.attributedText = message
        }
        self.notificationViewController.notificationView.invalidateIntrinsicContentSize()
        self.notificationViewController.notificationView.setNeedsLayout()

        if self.applicationTopMostViewController == self.notificationViewController {
            return
        }
        self.self.applicationTopMostViewController.present(self.notificationViewController, animated: true, completion: .none)
    }

    public func scheduleNotification(_ notification: Notification, inSeconds seconds: TimeInterval, notificationType: NotificationType) {
        cancelScheduledMessage(for: notificationType)

        let timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { [weak self] timer in
            self?.showNotification(notification)
            timer.invalidate()
        })

        timers[notificationType] = timer
    }
    
    public func dismissVisibleNotifications(_ animated: Bool = true) {
        guard self.applicationTopMostViewController == self.notificationViewController else {
            return
        }
        dismissNotification(animated)
    }

    public func cancelScheduledMessage(for notificationType: NotificationType) {
        timers[notificationType]?.invalidate()
        timers[notificationType] = nil
    }

    public func cancelAllScheduledNotifications() {
        for notificationType in NotificationType.all {
            cancelScheduledMessage(for: notificationType)
        }
    }

    func escalateFeedback(for notification: Notification, inSeconds seconds: TimeInterval) {
        cancelScheduledMessage(for: .importantEscalation)

        let timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { [unowned self] _ in
            self.cancelScheduledMessage(for: .importantEscalation)

            self.showNotification(notification, autoHide: false)
        })

        timers[.importantEscalation] = timer
    }

    // MARK: - Panel Visibility

    private func dismissNotification(_ animated: Bool) {
        self.notificationViewController.dismiss(animated: animated) {

        }
    }

}

// MARK: - Convenience Wrapper
extension LuckyNotification {
    public static func showNotification(icon: UIImage?, title: String?, description: String?, autoHide: Bool = true) {
        shared.showNotification(icon: icon, title: title, description: description, autoHide: autoHide)
    }

    public static func showNotification(_ notification: Notification, autoHide: Bool = true) {
        shared.showNotification(notification, autoHide: autoHide)
    }

    public static func scheduleNotification(_ notification: Notification, inSeconds seconds: TimeInterval, notificationType: NotificationType) {
        shared.scheduleNotification(notification, inSeconds: seconds, notificationType: notificationType)
    }
    
    public static func dismissVisibleNotifications(_ animated: Bool = true) {
        shared.dismissNotification(animated)
    }

    public static func cancelScheduledMessage(for notificationType: NotificationType) {
        shared.cancelScheduledMessage(for: notificationType)
    }

    public static func cancelAllScheduledNotifications() {
        shared.cancelAllScheduledNotifications()
    }

    public static func escalateFeedback(for notification: Notification, inSeconds seconds: TimeInterval) {
        shared.escalateFeedback(for: notification, inSeconds: seconds)
    }
}
