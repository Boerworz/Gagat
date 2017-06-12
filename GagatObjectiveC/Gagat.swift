//
//  GagatObjectiveC.swift
//  Gagat
//
//  Created by Tim Andersson on 2017-06-12.
//  Copyright © 2017 Cocoabeans Software. All rights reserved.
//

//
// +---------------------------------------------------------------------------------+
// | This file contains an Objective-C bridge for Gagat. It is the only component of |
// | the GagatObjectiveC target and has a dependency on the original Gagat target.   |
// +---------------------------------------------------------------------------------+
//

import Foundation
import Gagat

/// A type that knows how to toggle between two alternative visual styles.
@objc public protocol GGTStyleable {
	/// Activates the alternative style that is currently not active.
	///
	/// This method is called by Gagat at the start of a transition
	/// and at the end of a _cancelled_ transition (to revert to the
	/// previous style).
	func toggleActiveStyle()
}

/// The `GGTConfiguration` class allows clients to configure certain
/// aspects of the transition.
///
/// Initialize an empty instance of the class to use the defaults.
public class GGTConfiguration: NSObject {
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

	fileprivate var toSwiftRepresentation: Gagat.Configuration {
		return Gagat.Configuration(jellyFactor: jellyFactor)
	}
}

/// Represents a configured transition and allows clients to
/// access properties that can be modified after configuration.
public class GGTTransitionHandle: NSObject {
	private let wrappedHandle: Gagat.TransitionHandle

	fileprivate init(byWrapping handle: Gagat.TransitionHandle) {
		wrappedHandle = handle
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
		return wrappedHandle.panGestureRecognizer
	}
}

public class GGTManager: NSObject {

	/// Configures everything that's needed by Gagat to begin handling the transition
	/// in the specified window.
	///
	/// - important: You *must* keep a reference to the `GGTTransitionHandle`
	///              returned by this method even if you don't intend to access
	///              any of its properties.
	///              All Gagat-related objects will be torn down when the
	///              handle is deallocated, and the client will need to call
	///              `-[GGTManager configureForWindow:withStyleableObject:usingConfiguration:]`
	///              again to re-enable the Gagat transition.
	///
	/// - note: This method shouldn't be called multiple times for the same window
	///         unless the returned handle has been deallocated.
	///
	/// - parameter window: The window that the user will pan in to trigger the
	///             transition.
	/// - parameter styleableObject: An object that conforms to `GGTStyleable` and
	///             which is responsible for toggling to the alternative style when
	///             the transition is triggered or cancelled.
	/// - parameter configuration: The configuration to use for the transition.
	///
	/// - returns: A new instance of `GGTTransitionHandle`.
	public class func configure(forWindow window: UIWindow, withStyleableObject styleableObject: GGTStyleable, usingConfiguration configuration: GGTConfiguration = GGTConfiguration()) -> GGTTransitionHandle {
		let styleableObjectProxy = GagatStyleableSwiftToObjCProxy(target: styleableObject)
		let handle = Gagat.configure(for: window, with: styleableObjectProxy, using: configuration.toSwiftRepresentation)
		return GGTTransitionHandle(byWrapping: handle)
	}
	
}

/// `GagatStyleableSwiftToObjCProxy` is used internally to bridge the Swift-only
/// `GagatStyleable` type to the `GGTStyleable` type.
private struct GagatStyleableSwiftToObjCProxy: GagatStyleable {
	private let target: GGTStyleable

	init(target: GGTStyleable) {
		self.target = target
	}

	func toggleActiveStyle() {
		target.toggleActiveStyle()
	}
}
