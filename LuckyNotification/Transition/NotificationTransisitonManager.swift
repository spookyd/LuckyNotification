//
//  NotificationTransisitonManager.swift
//  LuckyNotification
//
//  Created by Luke Davis on 2/2/19.
//  Copyright © 2019 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

public protocol NotificationTransitioningDelegate: UIViewControllerTransitioningDelegate {
    var interactionTransition: UIPercentDrivenInteractiveTransition? { get }
    func updateConfiguration(_ configuration: NotificationConfiguration)
}

public class NotificationTransitionManager: NSObject, NotificationTransitioningDelegate {

    public var interactionTransition: UIPercentDrivenInteractiveTransition?
    private var presentationController: NotificationPresentationController?

    public private(set) var isDismisCompleted: Bool = false

    public override init() {
        super.init()
    }

    public func updateConfiguration(_ configuration: NotificationConfiguration) {
        presentationController?.edgeInsets = configuration.layoutPadding
        presentationController?.shadowRadius = configuration.shadowRadius
        presentationController?.shadowOpacity = configuration.shadowOpacity
        presentationController?.shadowColor = configuration.shadowColor
        presentationController?.shadowOffset = configuration.shadowOffset
    }

    @objc
    fileprivate func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let gestureView = gesture.view,
            let containerView = self.presentationController?.containerView else { return }
        let translate = gesture.translation(in: containerView)
        let percent = -(translate.y / gestureView.bounds.height)
        if gesture.state == .began {
            gesture.setTranslation(.zero, in: containerView)
            interactionTransition = UIPercentDrivenInteractiveTransition()
            self.isDismisCompleted = false
            self.presentationController?.presentingViewController.dismiss(animated: true, completion: .none)
        } else if gesture.state == .changed {
            interactionTransition?.update(percent)
        } else if gesture.state == .ended {
            let velocity = gesture.velocity(in: containerView)
            if percent > 0.5 || velocity.y < -1000 {
                interactionTransition?.finish()
                self.isDismisCompleted = true
            } else {
                interactionTransition?.cancel()
            }
            interactionTransition = nil
        }
    }

}

extension NotificationTransitionManager {

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        self.presentationController = NotificationPresentationController(presentedViewController: presented, presenting: presenting)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        self.presentationController?.presentedView?.addGestureRecognizer(panGesture)
        return self.presentationController
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return NotificationTransitionAnimator(presentationStyle: .present)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return NotificationTransitionAnimator(presentationStyle: .dismiss)
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionTransition
    }

}
