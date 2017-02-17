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
		
		enum Direction {
			case up, down, left, right
			
			static let horizontal: [Direction] = [.left, .right]
			static let vertical: [Direction] = [.up, .down]
		}
		
		let supportedDirections: [Direction]
		let jellyFactor: Double
		
		init(jellyFactor: Double = 1.0, supportedDirections: [Direction] = [.down]) {
			self.jellyFactor = jellyFactor
			self.supportedDirections = supportedDirections
		}
	}
	
	struct TransitionHandler {
		var enabled: Bool = true
		let coordinator: TransitionCoordinator
		
		init(coordinator: TransitionCoordinator) {
			self.coordinator = coordinator
		}
	}
	
	static func configure(for window: UIWindow, using configuration: Configuration = Configuration(), with styleableObject: GagatStyleable) -> TransitionHandler {
		let coordinator = setupTransitionCoordinator(in: window, using: configuration, with: styleableObject)
		return TransitionHandler(coordinator: coordinator)
	}
	
	private static func setupTransitionCoordinator(in view: UIView, using configuration: Configuration, with styleableObject: GagatStyleable) -> TransitionCoordinator {
		let coordinator = TransitionCoordinator(targetView: view, configuration: configuration, styleableObject: styleableObject)
		
		let panRecognizer = UIPanGestureRecognizer(target: coordinator, action: #selector(TransitionCoordinator.panRecognizerDidChange(_:)))
		panRecognizer.maximumNumberOfTouches = 2
		panRecognizer.minimumNumberOfTouches = 2
		panRecognizer.delegate = coordinator
		view.addGestureRecognizer(panRecognizer)
		
		return coordinator
	}
}
