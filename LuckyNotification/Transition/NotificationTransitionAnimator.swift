//
//  NotificationTransitionAnimator.swift
//  LuckyNotification
//
//  Created by Luke Davis on 2/4/19.
//  Copyright © 2019 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

public class NotificationTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    public enum PresentationStyle {
        case present
        case dismiss
    }

    let duration: TimeInterval

    let presentationStyle: PresentationStyle

    public init(presentationStyle: PresentationStyle, duration: TimeInterval = 0.3) {
        self.presentationStyle = presentationStyle
        self.duration = duration
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch presentationStyle {
        case .present:
            animatePresentationTransition(using: transitionContext)
        case .dismiss:
            animateDismissalTransition(using: transitionContext)
        }
    }

    // MARK: - Animation Implementation

    private func animatePresentationTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return
        }

        transitionContext.containerView.addSubview(toVC.view)

        let presentedFrame = transitionContext.finalFrame(for: toVC)
        var dismissedFrame = presentedFrame
        dismissedFrame.origin.y = -toVC.view.frame.size.height

        let initialFrame = dismissedFrame
        let finalFrame = presentedFrame

        let animationDuration = transitionDuration(using: transitionContext)
        toVC.view.frame = initialFrame
        UIView.animate(withDuration: animationDuration, animations: {
            toVC.view.frame = finalFrame
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

    private func animateDismissalTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            return
        }

        let presentedFrame = transitionContext.finalFrame(for: fromVC)
        var dismissedFrame = presentedFrame
        dismissedFrame.origin.y = -fromVC.view.frame.size.height

        let initialFrame = presentedFrame
        let finalFrame = dismissedFrame

        let animationDuration = transitionDuration(using: transitionContext)
        fromVC.view.frame = initialFrame
        UIView.animate(withDuration: animationDuration, animations: {
            fromVC.view.frame = finalFrame
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

}
