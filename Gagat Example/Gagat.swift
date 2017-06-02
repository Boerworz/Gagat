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
	func toggleActiveStyle()
}

struct Gagat {
	
	struct Configuration {
		let jellyFactor: Double

		static var defaults: Configuration {
			return Configuration(jellyFactor: 1.0)
		}
	}
	
	struct TransitionHandle {
		private let coordinator: TransitionCoordinator
		
		fileprivate init(coordinator: TransitionCoordinator) {
			self.coordinator = coordinator
		}

		var panGestureRecognizer: UIPanGestureRecognizer {
			return coordinator.panGestureRecognizer
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

		let coordinator = TransitionCoordinator(targetView: window, configuration: configuration, styleableObject: styleableObject)
		return TransitionHandle(coordinator: coordinator)
	}
}
