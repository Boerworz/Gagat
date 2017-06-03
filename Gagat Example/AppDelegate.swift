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
	var transitionHandle: Gagat.TransitionHandle!

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Configure Gagat for the applications only window using a jelly factor that is
		// slightly larger than the default factor of 1.0.
		//
		// Note: Make sure you keep a reference to the value returned from `Gagat.configure(for:using:)`.
		// If this object is deallocated then the Gagat transition will no longer work.
		// You also need the returned value if you have any scroll views in your application that might
		// interfere with Gagat's pan gesture. See `ArchiveTableViewController.viewDidLoad()`.
		let configuration = Gagat.Configuration(jellyFactor: 1.5)
		transitionHandle = Gagat.configure(for: window!, using: configuration)
		
		return true
	}

}

