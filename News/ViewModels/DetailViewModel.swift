//
//  DetailViewModel.swift
//  News
//
//  Created by vi nguyen on 12/12/17.
//  Copyright © 2017 com.vinguyen. All rights reserved.
//

import Foundation

class DetailViewModel {
	let url: String
	init?(url: String?) {
		guard let url = url else { return nil }
		self.url = url
	}
}
