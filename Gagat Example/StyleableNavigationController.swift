//
//  StyleableNavigationController.swift
//  Gagat
//
//  Created by Tim Andersson on 2017-06-03.
//  Copyright © 2017 Cocoabeans Software. All rights reserved.
//

import UIKit
import Gagat

class StyleableNavigationController: UINavigationController {

	fileprivate var useDarkMode = false {
		didSet {
			navigationBar.barStyle = useDarkMode ? .black : .default
		}
	}
}

extension StyleableNavigationController: GagatStyleable {

	func styleTransitionWillBegin() {
		// Do any work you might need to do before the transition snapshot is taken.
		if let styleableChildViewController = topViewController as? GagatStyleable {
			styleableChildViewController.styleTransitionWillBegin()
		}
	}

	func styleTransitionDidEnd() {
		// Do any work you might need to do once the transition has completed.
		if let styleableChildViewController = topViewController as? GagatStyleable {
			styleableChildViewController.styleTransitionDidEnd()
		}
	}

	func toggleActiveStyle() {
		useDarkMode = !useDarkMode

		// It's up to us to get any child view controllers to
		// toggle their active style. In this example application we've made
		// the child view controller also conform to `GagatStyleable`, but
		// this is not required by Gagat.
		if let styleableChildViewController = topViewController as? GagatStyleable {
			styleableChildViewController.toggleActiveStyle()
		}
	}
}
