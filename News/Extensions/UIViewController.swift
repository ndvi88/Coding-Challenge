//
//  UIViewController.swift
//  News
//
//  Created by vi nguyen on 12/12/17.
//  Copyright © 2017 com.vinguyen. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
	
	func showInfoAlert(_ message: String, title: String? = nil, completion: (() -> Void)? = nil) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
			if let handler = completion {
				handler()
			}
		})
		alertController.addAction(defaultAction)
		
		present(alertController, animated: true, completion: nil)
	}
}
