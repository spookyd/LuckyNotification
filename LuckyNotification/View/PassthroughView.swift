//
//  PassthroughView.swift
//  LuckyNotification
//
//  Created by Luke Davis on 2/6/19.
//  Copyright © 2019 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

public class PassthroughView: UIView {
    public var passthroughView: UIView?
    
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var hit = super.hitTest(point, with: event)
        if hit == self {
            guard let passthrough = self.passthroughView else {
                return hit
            }
            let convertedPoint = self.convert(point, to: passthrough)
            if let passthroughHit = passthrough.hitTest(convertedPoint, with: event) {
                hit = passthroughHit
            }
        }
        return hit
    }
    
}
