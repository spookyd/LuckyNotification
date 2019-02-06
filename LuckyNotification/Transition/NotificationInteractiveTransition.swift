//
//  NotificationInteractiveTransition.swift
//  LuckyNotification
//
//  Created by Luke Davis on 2/5/19.
//  Copyright © 2019 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

public class NotificationInteractiveTransition: UIPercentDrivenInteractiveTransition {

    private var transitionContext: UIViewControllerContextTransitioning?
    private var presentedViewController: UIViewController
    private var interactiveView: UIView
    private var panGesture: UIPanGestureRecognizer?

    public init(presentedViewController: UIViewController) {
        self.presentedViewController = presentedViewController
        self.interactiveView = presentedViewController.view
        super.init()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        self.panGesture = panGesture
        interactiveView.addGestureRecognizer(panGesture)
    }

    public override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
        self.transitionContext = transitionContext
    }

    @objc
    private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.transitionContext?.containerView)
        let percentage: CGFloat
        if let containerView = self.transitionContext?.containerView {
            percentage = -(translation.y) / containerView.bounds.height
        } else {
            percentage = 0
        }
        switch gesture.state {
        case .began:
            gesture.setTranslation(.zero, in: self.transitionContext?.containerView)
            presentedViewController.dismiss(animated: true, completion: .none)
        case .changed:
            self.update(percentage)
        case .ended:
            let velocity = gesture.velocity(in: self.transitionContext?.containerView)
            if (percentage > 0.45 && velocity.y == 0) || velocity.y < -1000 {
//                self.isFinished = true
                self.finish()
            } else {
                self.cancel()
            }
        default:
            break
        }
    }

}
