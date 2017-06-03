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

	private struct Style {
		var navigationBarStyle: UIBarStyle
		var statusBarStyle: UIStatusBarStyle

		static let dark = Style(
			navigationBarStyle: .black,
			statusBarStyle: .lightContent
		)

		static let light = Style(
			navigationBarStyle: .default,
			statusBarStyle: .default
		)
	}

	private var currentStyle: Style {
		return useDarkMode ? .dark : .light
	}

	fileprivate var useDarkMode = false {
		didSet { apply(currentStyle) }
	}

	private func apply(_ style: Style) {
		navigationBar.barStyle = style.navigationBarStyle
		UIApplication.shared.statusBarStyle = style.statusBarStyle
	}

}

extension StyleableNavigationController: GagatStyleable {
	func toggleActiveStyle() {
		useDarkMode = !useDarkMode

		// Gagat only tells the window's root view controller to toggle its
		// active style. It's up to us to get any child view controllers to
		// toggle their active style. In this example application we've made
		// the child view controller also conform to `GagatStyleable`, but
		// this is not required by Gagat.
		if let styleableChildViewController = topViewController as? GagatStyleable {
			styleableChildViewController.toggleActiveStyle()
		}
	}
}
