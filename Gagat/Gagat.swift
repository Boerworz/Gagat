//
//  Gagat.swift
//  Gagat
//
//  Created by Tim Andersson on 2017-02-17.
//  Copyright © 2017 Cocoabeans Software. All rights reserved.
//

import Foundation
import UIKit

protocol GagatStyleable {
	func applyNextStyle()
}

struct Gagat {
	
	struct Configuration {
		let jellyFactor: Double

		static var defaults: Configuration {
			return Configuration(jellyFactor: 1.0)
		}
	}
	
	struct TransitionHandle {
		fileprivate let coordinator: TransitionCoordinator
		
		fileprivate init(coordinator: TransitionCoordinator) {
			self.coordinator = coordinator
		}
	}
	
	static func configure(for window: UIWindow, using configuration: Configuration = .defaults) -> TransitionHandle? {
		guard let rootViewController = window.rootViewController else {
			assert(false, "Gagat Error: \(window) does not have a root view controller.")
			return nil
		}

		guard let styleableObject = rootViewController as? GagatStyleable else {
			assert(false, "Gagat Error: \(rootViewController) does not conform to `GagatStyleable`.")
			return nil
		}

		let coordinator = setupTransitionCoordinator(for: window, with: styleableObject, using: configuration)
		return TransitionHandle(coordinator: coordinator)
	}
	
	private static func setupTransitionCoordinator(for view: UIView, with styleableObject: GagatStyleable, using configuration: Configuration) -> TransitionCoordinator {
		let coordinator = TransitionCoordinator(targetView: view, configuration: configuration, styleableObject: styleableObject)
		
		let panRecognizer = UIPanGestureRecognizer(target: coordinator, action: #selector(TransitionCoordinator.panRecognizerDidChange(_:)))
		panRecognizer.maximumNumberOfTouches = 2
		panRecognizer.minimumNumberOfTouches = 2
		panRecognizer.delegate = coordinator
		view.addGestureRecognizer(panRecognizer)
		
		return coordinator
	}
}
