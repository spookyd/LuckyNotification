//
//  NotificationPresentationController.swift
//  LuckyNotification
//
//  Created by Luke Davis on 1/27/19.
//  Copyright © 2019 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

public class NotificationPresentationController: UIPresentationController {

    public var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

    private var passthroughView: PassthroughView?

    var minimumHeight: CGFloat = NotificationConfiguration.default.minimumHeight
    var shadowOffset: CGSize = NotificationConfiguration.default.shadowOffset
    var shadowColor: UIColor = NotificationConfiguration.default.shadowColor
    var shadowOpacity: Float = NotificationConfiguration.default.shadowOpacity
    var shadowRadius: CGFloat = NotificationConfiguration.default.shadowRadius

    public override var presentationStyle: UIModalPresentationStyle {
        return .overCurrentContext
    }

    public override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = self.containerView else { return .zero }
        let size = self.size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView.frame.size)
        let presentedX = (containerView.frame.width - size.width) / 2
        let presentedY: CGFloat
        if #available(iOS 11.0, *) {
            presentedY = presentingViewController.view.safeAreaInsets.top + self.edgeInsets.top
        } else {
            presentedY = presentingViewController.view.layoutMargins.top + self.edgeInsets.top
        }
        let origin = CGPoint(x: presentedX, y: presentedY)
        return CGRect(origin: origin, size: size)
    }

    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    public override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    public override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        let preferredContentSize = container.preferredContentSize
        let verticalPadding = self.edgeInsets.left + self.edgeInsets.right
        let maxWidth = parentSize.width - verticalPadding
        let width = calculateFittingMetric(preferredContentSize.width, restrictedBy: maxWidth)
        let horizontalPadding = self.edgeInsets.top + self.edgeInsets.bottom
        let maxHeight: CGFloat = parentSize.height - horizontalPadding
        let height = calculateFittingMetric(preferredContentSize.height, restrictedBy: maxHeight)
        return CGSize(width: width, height: max(minimumHeight, height))
    }

    private func calculateFittingMetric(_ metric: CGFloat, restrictedBy restrictingMetric: CGFloat) -> CGFloat {
        if metric == UIView.noIntrinsicMetric {
            return restrictingMetric
        }
        return min(restrictingMetric, metric)
    }

    public override func presentationTransitionWillBegin() {
        let passthrough = PassthroughView(frame: self.containerView?.frame ?? .zero)
        passthrough.passthroughView = self.presentingViewController.view
        self.containerView?.addSubview(passthrough)
        if let childSubView = self.presentedView?.subviews.first,
            let cornerRadius = self.presentedView?.layer.cornerRadius {
            childSubView.clipsToBounds = true
            childSubView.layer.cornerRadius = cornerRadius
        }
        self.presentedView?.layer.shadowOffset = self.shadowOffset
        self.presentedView?.layer.shadowColor = self.shadowColor.cgColor
        self.presentedView?.layer.shadowOpacity = self.shadowOpacity
        self.presentedView?.layer.shadowRadius = self.shadowRadius
        super.presentationTransitionWillBegin()
    }

    public override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            passthroughView?.removeFromSuperview()
        }
    }

}
