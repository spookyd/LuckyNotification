//
//  NotificationViewController.swift
//  LuckyNotification
//
//  Created by Luke Davis on 1/27/19.
//  Copyright © 2019 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

open class NotificationViewController: UIViewController {

    lazy var notificationView: NotificationView = {
        let view = NotificationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        } else {
            view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        }
        return view
    }()

    public init() {
        super.init(nibName: .none, bundle: .none)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 12
        self.view.addSubview(notificationView)
        pinNotificationView()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        preferredContentSize = self.notificationView.intrinsicContentSize
    }

    private func pinNotificationView() {
        let safeArea: UILayoutGuide
        if #available(iOS 11.0, *) {
            safeArea = self.view.safeAreaLayoutGuide
        } else {
            safeArea = self.view.layoutMarginsGuide
        }
        NSLayoutConstraint.activate([
            notificationView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            notificationView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            safeArea.trailingAnchor.constraint(equalTo: notificationView.trailingAnchor),
            safeArea.bottomAnchor.constraint(equalTo: notificationView.bottomAnchor)
        ])
    }

}
