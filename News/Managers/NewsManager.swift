//
//  NewsManager.swift
//  News
//
//  Created by vi nguyen on 12/12/17.
//  Copyright © 2017 com.vinguyen. All rights reserved.
//

import Foundation
import Alamofire

enum NewsError: Error {
	case missingBaseURL
	case missingApiKey
	case invalidURL
	var localizedDescription: String {
		switch self {
		case .missingApiKey:
			return "Missing api key"
		case .missingBaseURL:
			return "Missing base url"
		case .invalidURL:
			return "url is invalid"
		}
	}
}
class NewsManager {
	private let networkServiceManager: NetworkServiceManager
	private let dataManager: DataManager
	
	init(networkServiceManager: NetworkServiceManager, dataManager: DataManager) {
		self.networkServiceManager = networkServiceManager
		self.dataManager = dataManager
	}
	
	func loadNews(from source: String, completion: @escaping (Alamofire.Result<Void>) -> Void){
		guard let baseURL = self.baseURL else {
			completion(.failure(NewsError.missingBaseURL))
			return
		}
		guard let apiKey = self.apiKey else {
			completion(.failure(NewsError.missingApiKey))
			return
		}
		let parameters = ["sources" : source, "apiKey" : apiKey]
		
		guard let urlRequest = NetworkServiceManager.url(for: baseURL, path: "/v2/everything", parameters: parameters) else {
			completion(.failure(NewsError.invalidURL))
			return
		}
		
		let resource = Resource<Void>(url: urlRequest) { dict in
			guard let result = dict as? JSONDictionary, let data = result["articles"] as? [JSONDictionary] else { return nil }
			
			self.dataManager.deleteWithEntity(News.self)
			self.dataManager.saveContext()
			_ = data.flatMap { News(dictionary: $0, context: self.dataManager.dataStack.viewContext) }
			self.dataManager.saveContext()
			
			return Void()
		}
		networkServiceManager.load(resource: resource, completion: completion)
		
	}
}

private extension NewsManager {
	private var baseURL: URL? {
		guard let infoDict = Bundle.main.infoDictionary, let baseURL = infoDict["BaseURL"] as? String else { return nil }
		return URL(string: baseURL)
	}
	private var apiKey: String? {
		return Bundle.main.infoDictionary?["APIKey"] as? String
	}
}
