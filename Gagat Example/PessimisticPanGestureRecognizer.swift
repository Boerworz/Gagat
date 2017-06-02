//
//  PessimisticPanGestureRecognizer.swift
//  Gagat
//
//  Created by Tim Andersson on 2017-05-25.
//  Copyright © 2017 Cocoabeans Software. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

/// `PessimisticPanGestureRecognizer` is a `UIPanGestureRecognizer` subclass that
/// fails earlier than the base `UIPanGestureRecognizer` class.
/// More specifically it fails if the user drags fewer than the minimum number
/// of required fingers past a certain threshold (10pt).
///
/// In Gagat, this is used as the pan gesture recognizer that drives the
/// style transition. It is required in order to let the transition work
/// in harmony with any `UIScrollViews` (e.g. `UITableView`) that exist in the
/// application.
class PessimisticPanGestureRecognizer: UIPanGestureRecognizer {

	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
		let hasLessThanNumberOfRequiredTouches = (event.allTouches?.count ?? 0) < minimumNumberOfTouches
		let hasDraggedPastFailureThreshold = absoluteDistanceFromStartingPoint < 10.0
		if hasLessThanNumberOfRequiredTouches && hasDraggedPastFailureThreshold {
			state = .failed
		} else {
			super.touchesMoved(touches, with: event)
		}
	}

	private var absoluteDistanceFromStartingPoint: CGFloat {
		let translation = self.translation(in: view)
		return sqrt(pow(translation.x, 2) + pow(translation.y, 2))
	}
	
}
