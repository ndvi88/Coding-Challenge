//
//  ManagerProvider.swift
//  News
//
//  Created by vi nguyen on 12/12/17.
//  Copyright © 2017 com.vinguyen. All rights reserved.
//

import UIKit

class ManagerProvider {
	let dataManager: DataManager
	let networkServiceManager: NetworkServiceManager
	
	static let sharedInstance = ManagerProvider(networkServiceManager: NetworkServiceManager(), dataManager: DataManager())
	
	init(networkServiceManager: NetworkServiceManager, dataManager: DataManager) {
		self.networkServiceManager = networkServiceManager
		self.dataManager = dataManager
	}
	
	private (set) lazy var newsManager: NewsManager = NewsManager(networkServiceManager: self.networkServiceManager, dataManager: self.dataManager)
	
}
