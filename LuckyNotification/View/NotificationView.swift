//
//  NotificationView.swift
//  LuckyNotification
//
//  Created by Luke Davis on 1/27/19.
//  Copyright © 2019 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

open class NotificationView: UIVisualEffectView {

    public var iconSize: CGSize = CGSize(width: 40, height: 40) {
        didSet {
            for constraint in self.iconImageView.constraints {
                if self.iconImageView.widthAnchor == constraint.firstAnchor {
                    constraint.constant = iconSize.width
                } else if self.iconImageView.heightAnchor == constraint.firstAnchor {
                    constraint.constant = iconSize.height
                }
            }
            self.setNeedsLayout()
        }
    }
    public var spacing: CGFloat = 8 {
        didSet {
            self.containerView.spacing = spacing
            self.textContainerView.spacing = spacing
        }
    }

    private lazy var containerView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.iconImageView, self.textContainerView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .top
        view.distribution = .fill
        view.spacing = self.spacing
        return view
    }()

    /// The image to be displayed on the left of the notification
    public var image: UIImage? {
        get {
            return self.iconImageView.image
        }
        set {
            let previousValue = self.image
            self.iconImageView.isHidden = newValue == .none
            self.iconImageView.image = newValue
            if previousValue == .none && newValue != .none {
                if iconConstraints == .none {
                    self.iconConstraints = self.layoutIconView()
                }
                if let constraints = self.iconConstraints {
                    NSLayoutConstraint.activate(constraints)
                }
            } else if let constraints = self.iconConstraints, previousValue != .none && newValue == .none {
                NSLayoutConstraint.deactivate(constraints)
            }
        }
    }

    private var iconConstraints: [NSLayoutConstraint]?

    private lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private lazy var textContainerView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.titleLabel, self.descriptionLabel])
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = self.spacing
        return view
    }()

    public private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        view.textColor = UIColor(white: 0, alpha: 0.84)
        view.numberOfLines = 2
        view.textAlignment = .left
        view.lineBreakMode = .byWordWrapping
        return view
    }()

    public private(set) lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
        view.textColor = UIColor(white: 0, alpha: 0.64)
        view.numberOfLines = 0
        view.textAlignment = .left
        view.lineBreakMode = .byWordWrapping
        return view
    }()

    public init() {
        super.init(effect: UIBlurEffect(style: .prominent))
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override var intrinsicContentSize: CGSize {
        // Calculate height
        let totalTextHeight = self.titleLabel.intrinsicContentSize.height + self.descriptionLabel.intrinsicContentSize.height
        let textWithSpacingHeight = self.spacing + totalTextHeight
        let height = max(self.iconSize.height, textWithSpacingHeight)
        let paddedHeight = height + (self.directionalLayoutMargins.top + self.directionalLayoutMargins.bottom)
        return CGSize(width: UIView.noIntrinsicMetric, height: paddedHeight)
    }

    private func commonInit() {
        self.clipsToBounds = true
        self.contentView.clipsToBounds = true
        self.contentView.addSubview(self.containerView)
        NSLayoutConstraint.activate(layoutContentView())
    }

    private func layoutContentView() -> [NSLayoutConstraint] {
        return [
            self.containerView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            self.containerView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            self.layoutMarginsGuide.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            self.layoutMarginsGuide.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor)
        ]
    }

    private func layoutIconView() -> [NSLayoutConstraint] {
        return [
            iconImageView.widthAnchor.constraint(equalToConstant: self.iconSize.width),
            iconImageView.heightAnchor.constraint(equalToConstant: self.iconSize.height),
            iconImageView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.containerView.bottomAnchor.constraint(greaterThanOrEqualTo: iconImageView.bottomAnchor,
                                                       constant: 0)

        ]
    }

}
