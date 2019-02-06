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
    var message: NSAttributedString?

    public init(icon: UIImage? = .none, title: String? = .none, description: String? = .none) {
        self.icon = icon
        self.title = title
        self.description = description
        self.message = .none
    }
    
    public init(icon: UIImage? = .none, message: NSAttributedString? = .none) {
        self.icon = icon
        self.title = .none
        self.description = message?.string
        self.message = message
    }
    
}
