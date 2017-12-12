//
//  DetailViewController.swift
//  News
//
//  Created by vi nguyen on 12/12/17.
//  Copyright © 2017 com.vinguyen. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
	@IBOutlet private weak var spinner: UIActivityIndicatorView!
	var viewModel:DetailViewModel?
	private let webView: WKWebView = WKWebView()
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let viewModel = viewModel, let url = URL(string: viewModel.url) else { return }
		webView.translatesAutoresizingMaskIntoConstraints = false
		self.view.insertSubview(webView, at: 0)
		
		if #available(iOS 11, *) {
			viewRespectsSystemMinimumLayoutMargins = false
			view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		}
		let margins = view.layoutMarginsGuide
		NSLayoutConstraint.activate([
			webView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
			webView.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
			])
		
		if #available(iOS 11, *) {
			let guide = view.safeAreaLayoutGuide
			NSLayoutConstraint.activate([
				webView.topAnchor.constraintEqualToSystemSpacingBelow(guide.topAnchor, multiplier: 1.0),
				guide.bottomAnchor.constraintEqualToSystemSpacingBelow(webView.bottomAnchor, multiplier: 1.0)
				])
			
		} else {
			let standardSpacing: CGFloat = 1.0
			NSLayoutConstraint.activate([
				webView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing),
				bottomLayoutGuide.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: standardSpacing)
				])
		}
		webView.navigationDelegate = self
		let myRequest = URLRequest(url: url)
		webView.load(myRequest)
	}
}

extension DetailViewController:WKNavigationDelegate {
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		spinner.stopAnimating()
	}
}
