//
//  TransitionCoordinator.swift
//  Gagat
//
//  Created by Tim Andersson on 2017-02-17.
//  Copyright © 2017 Cocoabeans Software. All rights reserved.
//

import Foundation
import UIKit

class TransitionCoordinator: NSObject {

	fileprivate enum State {
		case idle
		case tracking
		case transitioning
	}

	/// The view (or window) that the transition should occur in, and
	/// which the pan gesture recognizer is installed in.
	fileprivate let targetView: UIView
	
	fileprivate let configuration: Gagat.Configuration
	private let styleableObject: GagatStyleable

	private(set) var panGestureRecognizer: PessimisticPanGestureRecognizer!

	fileprivate var state = State.idle
	
	init(targetView: UIView, styleableObject: GagatStyleable, configuration: Gagat.Configuration) {
		self.targetView = targetView
		self.configuration = configuration
		self.styleableObject = styleableObject

		super.init()

		setupPanGestureRecognizer(in: targetView)
	}

	deinit {
		panGestureRecognizer.view?.removeGestureRecognizer(panGestureRecognizer)
	}
	
	// MARK: - Pan gesture recognizer

	private func setupPanGestureRecognizer(in targetView: UIView) {
		let panGestureRecognizer = PessimisticPanGestureRecognizer(target: self, action: #selector(panRecognizerDidChange(_:)))
		panGestureRecognizer.maximumNumberOfTouches = 2
		panGestureRecognizer.minimumNumberOfTouches = 2
		panGestureRecognizer.delegate = self
		targetView.addGestureRecognizer(panGestureRecognizer)

		self.panGestureRecognizer = panGestureRecognizer
	}
	
	func panRecognizerDidChange(_ panRecognizer: PessimisticPanGestureRecognizer) {
		switch panRecognizer.state {
		case .began:
			beginInteractiveStyleTransition(withPanRecognizer: panRecognizer)
		case .changed:
			adjustMaskLayer(basedOn: panRecognizer)
		case .ended, .failed:
			endInteractiveStyleTransition(withPanRecognizer: panRecognizer)
		case .cancelled:
			cancelInteractiveStyleTransitionWithoutAnimation()
		default: break
		}
	}
	
	// MARK: - Interactive style transition
	
	/// During the interactive transition, this property contains a
	/// snapshot of the view when it was styled with the previous style
	/// (i.e. the style we're transitioning _from_).
	/// As the transition progresses, less and less of the snapshot view
	/// will be visible, revealing more of the real view which is styled
	/// with the new style.
	private var previousStyleTargetViewSnapshot: UIView?
	
	/// During the interactive transition, this property contains the layer
	/// used to mask the contents of `previousStyleTargetViewSnapshot`.
	/// When the user pans, the position and path of `snapshotMaskLayer` is
	/// adjusted to reflect the current translation of the pan recognizer.
	private var snapshotMaskLayer: CAShapeLayer?
	
	private func beginInteractiveStyleTransition(withPanRecognizer panRecognizer: PessimisticPanGestureRecognizer) {
		// We snapshot the targetView before applying the new style, and make sure
		// it's positioned on top of all the other content.
		previousStyleTargetViewSnapshot = targetView.snapshotView(afterScreenUpdates: false)
		targetView.addSubview(previousStyleTargetViewSnapshot!)
		targetView.bringSubview(toFront: previousStyleTargetViewSnapshot!)
		
		// When we have the snapshot we create a new mask layer that's used to
		// control how much of the previous view we display as the transition
		// progresses.
		snapshotMaskLayer = CAShapeLayer()
		snapshotMaskLayer?.path = UIBezierPath(rect: targetView.bounds).cgPath
		snapshotMaskLayer?.fillColor = UIColor.black.cgColor
		previousStyleTargetViewSnapshot?.layer.mask = snapshotMaskLayer
		
		// Now we're free to apply the new style. This won't be visible until
		// the user pans more since the snapshot is displayed on top of the
		// actual content.
		styleableObject.toggleActiveStyle()
		
		// Finally we make our first adjustment to the mask layer based on the
		// values of the pan recognizer.
		adjustMaskLayer(basedOn: panRecognizer)

		state = .tracking
	}
	
	private func adjustMaskLayer(basedOn panRecognizer: PessimisticPanGestureRecognizer) {
		adjustMaskLayerPosition(basedOn: panRecognizer)
		adjustMaskLayerPath(basedOn: panRecognizer)
	}
	
	private func adjustMaskLayerPosition(basedOn panRecognizer: PessimisticPanGestureRecognizer) {
		// We need to disable implicit animations since we don't want to
		// animate the position change of the mask layer.
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		let verticalTranslation = panRecognizer.translation(in: targetView).y
		if verticalTranslation < 0.0 {
			// We wan't to prevent the user from moving the mask layer out the
			// top of the targetView, since doing so would show the new style at
			// the bottom of the targetView instead.
			//
			// By resetting the translation we make sure there's no visual
			// delay between when the user tries to pan upwards and when they
			// start panning downwards again.
			panRecognizer.setTranslation(.zero, in: targetView)
			snapshotMaskLayer?.frame.origin.y = 0.0
		} else {
			// Simply move the mask layer as much as the user has panned.
			// Note that if we had used the _location_ of the pan recognizer
			// instead of the _translation_, the top of the mask layer would
			// follow the fingers exactly. Using the translation results in a
			// better user experience since the location of the mask layer is
			// instead relative to the distance moved, just like when moving a
			// piece of paper with our fingertips.
			snapshotMaskLayer?.frame.origin.y = verticalTranslation
		}
		
		CATransaction.commit()
	}
	
	private func adjustMaskLayerPath(basedOn panRecognizer: PessimisticPanGestureRecognizer) {
		let maskingPath = UIBezierPath()
		
		// Top-left corner...
		maskingPath.move(to: .zero)
		
		// ...arc to top-right corner...
		// This is all the code that is required to get the bouncy effect.
		// Since the control point of the quad curve depends on the velocity
		// of the pan recognizer, the path will "deform" more for a larger
		// velocity.
		// We don't need to do anything to animate the path back to its
		// non-deformed state since the pan gesture recognizer's target method
		// (panRecognizerDidChange(_:) in our case) is called periodically
		// even when the user stops moving their finger (until the velocity
		// reaches 0).
		// Note: To increase the bouncy effect, decrease the `damping` value.
		let damping = configuration.jellyFactor > 0.0 ? CGFloat(45.0 / configuration.jellyFactor) : 0.0
		let verticalOffset = damping > 0.0 ? panRecognizer.velocity(in: targetView).y / damping : 0.0
		let horizontalTouchLocation = panRecognizer.location(in: targetView).x
		maskingPath.addQuadCurve(to: CGPoint(x: targetView.bounds.maxX, y: 0.0), controlPoint: CGPoint(x: horizontalTouchLocation, y: verticalOffset))
		
		// ...to bottom-right corner...
		maskingPath.addLine(to: CGPoint(x: targetView.bounds.maxX, y: targetView.bounds.maxY))
		
		// ...to bottom-left corner...
		maskingPath.addLine(to: CGPoint(x: 0.0, y: targetView.bounds.maxY))
		
		// ...and close the path.
		maskingPath.close()
		
		snapshotMaskLayer?.path = maskingPath.cgPath
	}
	
	private func endInteractiveStyleTransition(withPanRecognizer panRecognizer: PessimisticPanGestureRecognizer) {
		let velocity = panRecognizer.velocity(in: targetView)
		let translation = panRecognizer.translation(in: targetView)
		
		let isMovingDownwards = velocity.y > 0.0
		let hasPassedThreshold = translation.y > targetView.bounds.midY
		
		// We support both completing the transition and cancelling the transition.
		// The transition to the new style should be completed if the user is panning
		// downwards or if they've panned enough that more than half of the new view
		// is already shown.
		let shouldCompleteTransition = isMovingDownwards || hasPassedThreshold
		
		if shouldCompleteTransition {
			completeInteractiveStyleTransition(withVelocity: velocity)
		} else {
			cancelInteractiveStyleTransition(withVelocity: velocity)
		}
	}

	private func cancelInteractiveStyleTransitionWithoutAnimation() {
		styleableObject.toggleActiveStyle()
		cleanupAfterInteractiveStyleTransition()
		state = .idle
	}
	
	private func cancelInteractiveStyleTransition(withVelocity velocity: CGPoint) {
		guard let snapshotMaskLayer = snapshotMaskLayer else {
			return
		}

		state = .transitioning
		
		// When cancelling the transition we simply animate the mask layer to its original
		// location (which means that the entire previous style snapshot is shown), then
		// reset the style to the previous style and remove the snapshot.
		animate(snapshotMaskLayer, to: .zero, withVelocity: velocity) {
			self.styleableObject.toggleActiveStyle()
			self.cleanupAfterInteractiveStyleTransition()
			self.state = .idle
		}
	}
	
	private func completeInteractiveStyleTransition(withVelocity velocity: CGPoint) {
		guard let snapshotMaskLayer = snapshotMaskLayer else {
			return
		}

		state = .transitioning
		
		// When completing the transition we slide the mask layer down to the bottom of
		// the targetView and then remove the snapshot. The further down the mask layer is,
		// the more of the underlying view is visible. When the mask layer reaches the
		// bottom of the targetView, the entire underlying view will be visible so removing
		// the snapshot will have no visual effect.
		let targetLocation = CGPoint(x: 0.0, y: targetView.bounds.maxY)
		animate(snapshotMaskLayer, to: targetLocation, withVelocity: velocity) {
			self.cleanupAfterInteractiveStyleTransition()
			self.state = .idle
		}
	}
	
	private func cleanupAfterInteractiveStyleTransition() {
		self.previousStyleTargetViewSnapshot?.removeFromSuperview()
		self.previousStyleTargetViewSnapshot = nil
		self.snapshotMaskLayer = nil
	}
}

extension TransitionCoordinator: UIGestureRecognizerDelegate {
	private typealias Degrees = Double

	private enum Direction {
		case up, down, left, right
	}
	
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		guard let panRecognizer = gestureRecognizer as? PessimisticPanGestureRecognizer else {
			return true
		}

		guard state == .idle else {
			return false
		}
		
		let translation = panRecognizer.translation(in: targetView)
		let panningAngle: Degrees = atan2(Double(translation.y), Double(translation.x)) * 360 / (Double.pi * 2)
		let panningDirection = direction(for: panningAngle)
		return panningDirection == .down
	}
	
	private func direction(for angle: Degrees) -> Direction {
		switch angle {
		case 45.0...135.0: return .down
		case 135.0...225.0: return .left
		case 225.0...315.0: return .up
		default: return .right
		}
	}
}
