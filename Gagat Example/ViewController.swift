//
//  ViewController.swift
//  Gagat
//
//  Created by Tim Andersson on 2017-02-17.
//  Copyright © 2017 Cocoabeans Software. All rights reserved.
//

import UIKit
import Gagat

class ViewController: UIViewController, GagatStyleable {
	private var useDarkMode: Bool = false {
		didSet {
			view.backgroundColor = useDarkMode ? .black : .white
			setNeedsStatusBarAppearanceUpdate()
		}
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return useDarkMode ? .lightContent : .default
	}
	
	func toggleActiveStyle() {
		useDarkMode = !useDarkMode
	}
}
