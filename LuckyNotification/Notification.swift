//
//  Notification.swift
//  LuckyNotification
//
//  Created by Luke Davis on 2/5/19.
//  Copyright © 2019 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

public struct Notification {

    public var icon: UIImage?
    public var title: String?
    public var description: String?

    public init(icon: UIImage? = .none, title: String? = .none, description: String? = .none) {
        self.icon = icon
        self.title = title
        self.description = description
    }
}
