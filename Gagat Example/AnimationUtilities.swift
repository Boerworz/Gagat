//
//  AnimationUtilities.swift
//  Gagat
//
//  Created by Tim Andersson on 2017-02-17.
//  Copyright © 2017 Cocoabeans Software. All rights reserved.
//

import Foundation
import QuartzCore

private func distance(from source: CGPoint, to destination: CGPoint) -> CGFloat {
	return sqrt(pow(destination.x - source.x, 2) + pow(destination.y - source.y, 2))
}

private func timeRequiredToMove(from source: CGPoint, to destination: CGPoint, withVelocity velocity: CGPoint) -> TimeInterval {
	let distanceToMove = distance(from: source, to: destination)
	let velocityMagnitude = sqrt(pow(velocity.x, 2) + pow(velocity.y, 2))
	let requiredTime = TimeInterval(abs(distanceToMove / velocityMagnitude))
	return requiredTime
}

private func maximumReasonableTimeToMove(from source: CGPoint, to destination: CGPoint) -> TimeInterval {
	let minimumReasonableVelocity: CGFloat = 300.0 // points per second, chosen empirically
	let distanceToMove = distance(from: source, to: destination)
	return TimeInterval(distanceToMove / minimumReasonableVelocity)
}

func animate(_ layer: CALayer, to targetPoint: CGPoint, withVelocity velocity: CGPoint, completion: @escaping () -> Void) {
	let startPoint = layer.position
	layer.position = targetPoint
	
	let positionAnimation = CABasicAnimation(keyPath: "position")
	positionAnimation.duration = min(
		maximumReasonableTimeToMove(from: startPoint, to: targetPoint),
		timeRequiredToMove(from: startPoint, to: targetPoint, withVelocity: velocity)
	)
	positionAnimation.fromValue = NSValue(cgPoint: startPoint)
	positionAnimation.toValue = NSValue(cgPoint: targetPoint)
	
	CATransaction.begin()
	CATransaction.setCompletionBlock(completion)
	
	layer.add(positionAnimation, forKey: "position")
	
	CATransaction.commit()
}
