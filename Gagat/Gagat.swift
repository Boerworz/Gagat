//
//  Gagat.swift
//  Gagat
//
//  Created by Tim Andersson on 2017-02-17.
//  Copyright © 2017 Cocoabeans Software. All rights reserved.
//

import Foundation
import UIKit

/// A type that knows how to toggle between two alternative visual styles.
public protocol GagatStyleable {
	/// Activates the alternative style that is currently not active.
	///
	/// This method is called by Gagat at the start of a transition
	/// and at the end of a _cancelled_ transition (to revert to the
	/// previous style).
	func toggleActiveStyle()

	/// Called when the style transition is about to begin. `toggleActiveStyle()` will be called just after this.
	func styleTransitionWillBegin()

	/// Called when the style transition ended.
	func styleTransitionDidEnd()
}

public struct Gagat {

	/// The `Configuration` struct allows clients to configure certain
	/// aspects of the transition.
	///
	/// Initialize an empty instance of the struct to use the defaults.
	public struct Configuration {
		/// Controls how much the border between the new and
		/// previous style is deformed when panning. The larger the
		/// factor is, the more the border is deformed.
		/// Specify a factor of 0 to entirely disable the deformation.
		///
		/// Defaults to 1.0.
		public let jellyFactor: Double

		public init(jellyFactor: Double = 1.0) {
			self.jellyFactor = jellyFactor
		}
	}

	/// Represents a configured transition and allows clients to
	/// access properties that can be modified after configuration.
	public struct TransitionHandle {
		private let coordinator: TransitionCoordinator
		
		fileprivate init(coordinator: TransitionCoordinator) {
			self.coordinator = coordinator
		}

		/// The pan gesture recognizer that Gagat uses to trigger and drive the
		/// transition.
		///
		/// You may use this property to configure the minimum or maximum number
		/// of required touches if you don't want to use the default two-finger
		/// pan. You may also use it to setup dependencies between this gesture
		/// recognizer and any other gesture recognizers in your application.
		///
		/// - important: You *must not* change the gesture recognizer's delegate
		///              or remove targets not added by the client.
		public var panGestureRecognizer: UIPanGestureRecognizer {
			return coordinator.panGestureRecognizer
		}
	}

	/// Configures everything that's needed by Gagat to begin handling the transition
	/// in the specified window.
	///
	/// - important: You *must* keep a reference to the `TransitionHandle`
	///              returned by this method even if you don't intend to access
	///              any of its properties.
	///              All Gagat-related objects will be torn down when the
	///              handle is deallocated, and the client will need to call
	///              `Gagat.configure(for:with:using:)` again to re-enable
	///              the Gagat transition.
	///
	/// - note: This method shouldn't be called multiple times for the same window
	///         unless the returned handle has been deallocated.
	///
	/// - parameter window: The window that the user will pan in to trigger the
	///             transition.
	/// - parameter styleableObject: An object that conforms to `GagatStyleable` and
	///             which is responsible for toggling to the alternative style when
	///             the transition is triggered or cancelled.
	/// - parameter configuration: The configuration to use for the transition.
	///
	/// - returns: A new instance of `TransitionHandle`.
	public static func configure(for window: UIWindow, with styleableObject: GagatStyleable, using configuration: Configuration = Configuration()) -> TransitionHandle {
		let coordinator = TransitionCoordinator(targetView: window, styleableObject: styleableObject, configuration: configuration)
		return TransitionHandle(coordinator: coordinator)
	}
}
