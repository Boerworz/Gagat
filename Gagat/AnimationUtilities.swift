//
//  AnimationUtilities.swift
//  Gagat
//
//  Created by Tim Andersson on 2017-02-17.
//  Copyright © 2017 Cocoabeans Software. All rights reserved.
//

import Foundation
import QuartzCore

// MARK: - Animation utilities

func timeRequiredToMove(from: CGPoint, to: CGPoint, withVelocity velocity: CGPoint) -> TimeInterval {
	let distanceToMove = sqrt(pow(to.x - from.x, 2) + pow(to.y - from.y, 2))
	let velocityMagnitude = sqrt(pow(velocity.x, 2) + pow(velocity.y, 2))
	let requiredTime = TimeInterval(abs(distanceToMove / velocityMagnitude))
	return requiredTime
}

func animate(_ layer: CALayer, to targetPoint: CGPoint, withVelocity velocity: CGPoint, completion: @escaping () -> Void) {
	let startPoint = layer.position
	layer.position = targetPoint
	
	let positionAnimation = CABasicAnimation(keyPath: "position")
	positionAnimation.duration = min(3.0, timeRequiredToMove(from: startPoint, to: targetPoint, withVelocity: velocity))
	positionAnimation.fromValue = NSValue(cgPoint: startPoint)
	positionAnimation.toValue = NSValue(cgPoint: targetPoint)
	
	CATransaction.begin()
	CATransaction.setCompletionBlock(completion)
	
	layer.add(positionAnimation, forKey: "position")
	
	CATransaction.commit()
}
