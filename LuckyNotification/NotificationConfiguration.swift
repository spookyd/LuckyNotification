//
//  NotificationConfiguration.swift
//  LuckyNotification
//
//  Created by Luke Davis on 2/5/19.
//  Copyright © 2019 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit


/// A shim for directional support on ios 10.
public struct DirectionalEdgeInsets {
    public var top: CGFloat
    public var leading: CGFloat
    public var bottom: CGFloat
    public var trailing: CGFloat
    public init(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) {
        self.leading = leading
        self.top = top
        self.trailing = trailing
        self.bottom = bottom
    }
    func toUIEdgeInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: self.top, left: self.leading, bottom: self.bottom, right: self.trailing)
    }
    @available(iOS 11.0, *)
    func toNSDirectionalEdgeInsets() -> NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: self.top, leading: self.leading, bottom: self.bottom, trailing: self.trailing)
    }
    
}

public struct NotificationConfiguration {
    // MARK: - Notification Layout

    /// The padding to be applied to the presented notification. Default: top: 16, left: 16, bottom: 16, right: 16
    public var layoutPadding: UIEdgeInsets

    /// The margin to be applied to the content within the notification. Default: top: 20, leading: 20, bottom: 20, trailing: 20
    public var layoutMargin: DirectionalEdgeInsets

    /// The size of the icon on the leading edge. Default is 40 x 40
    public var iconSize: CGSize

    /// The amount of spacing between the elements within the notification. Default: 8
    public var contentSpacing: CGFloat

    // MARK: - Notification Styling

    /// The font to be used for the title label. Default: UIFont.TextStyle.headline
    public var titleFont: UIFont

    /// The color to be used for the title label. Default: white: 0, alpha: 0.84
    public var titleColor: UIColor

    /// The font to be used for the description label. Default: UIFont.TextStyle.subheadline
    public var descriptionFont: UIFont

    /// The color to be used for the description label. Default: white: 0, alpha: 0.64
    public var descriptionColor: UIColor

    // MARK: - Presentation Appearance
    /// The shadow offset to be applied to the presented notification. Default: width: 0, height: 5
    public var shadowOffset: CGSize

    /// The shadow color to be applied to the presented notification. Default: black
    public var shadowColor: UIColor

    /// The shadow opacity to be applied to the presented notification. Default: 0.4
    public var shadowOpacity: Float

    /// The shadow radius to be applied to the presented notification. Default: 8
    public var shadowRadius: CGFloat

    /// The amount of corner radius to be applied to the presented notification. Default: 12
    public var cornerRadius: CGFloat

    // MARK: - Presentation Animation
}

extension NotificationConfiguration {
    public static let `default`: NotificationConfiguration = {
       return NotificationConfiguration(layoutPadding: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16),
                                        layoutMargin: DirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20),
                                        iconSize: CGSize(width: 40, height: 40),
                                        contentSpacing: 8,
                                        titleFont: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline),
                                        titleColor: UIColor(white: 0, alpha: 0.84),
                                        descriptionFont: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline),
                                        descriptionColor: UIColor(white: 0, alpha: 0.64),
                                        shadowOffset: CGSize(width: 0, height: 5),
                                        shadowColor: UIColor.black,
                                        shadowOpacity: 0.4,
                                        shadowRadius: 8,
                                        cornerRadius: 12)
    }()

}
