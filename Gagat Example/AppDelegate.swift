//
//  AppDelegate.swift
//  Gagat
//
//  Created by Tim Andersson on 2017-02-17.
//  Copyright © 2017 Cocoabeans Software. All rights reserved.
//

import UIKit
import Gagat

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	private var transitionHandle: Gagat.TransitionHandle!

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Configure Gagat for the applications only window using a jelly factor that is
		// slightly larger than the default factor of 1.0. We'll use the root view controller
		// as the styleable object, but you can use any object that conforms to `GagatStyleable`.
		//
		// Note: Make sure you keep a reference to the value returned from `Gagat.configure(for:using:)`.
		// If this object is deallocated then the Gagat transition will no longer work.
		let configuration = Gagat.Configuration(jellyFactor: 1.5)
		let styleableNavigationController = window!.rootViewController as! StyleableNavigationController
		transitionHandle = Gagat.configure(for: window!, with: styleableNavigationController, using: configuration)

		return true
	}

}
