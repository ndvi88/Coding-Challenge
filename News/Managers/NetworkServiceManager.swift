//
//  NetworkServiceManager.swift
//  News
//
//  Created by vi nguyen on 12/11/17.
//  Copyright © 2017 com.vinguyen. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkServiceError: Error {
	case failedParsing
	var localizedDescription: String {
		switch self {
		case .failedParsing:
			return "Failed when parsing data"
		}
	}
}

class NetworkServiceManager {
	let sessionManager: SessionManager
	
	init() {
		let serverTrustPolicy = ServerTrustPolicy.pinCertificates(
			certificates: ServerTrustPolicy.certificates(),
			validateCertificateChain: false,
			validateHost: true
		)
		let serverTrustPolicies: [String: ServerTrustPolicy] = [
			"newsapi.org.cer": serverTrustPolicy
		]
		sessionManager = SessionManager(configuration: URLSessionConfiguration.default, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
	}
	
	func load<A>(resource: Resource<A>, parseQueue: DispatchQueue = .global(), completion: @escaping (Alamofire.Result<A>) -> Void) {
		sessionManager.request(resource.url, method: resource.method, parameters: resource.parameters, headers: resource.headers).responseData(queue: parseQueue) { response in
			switch response.result {
			case let .success(data):
				if let result = resource.parse(data) {
					self.completeOnMainQueue(completion, result: .success(result))
				} else {
					self.completeOnMainQueue(completion, result: .failure(NetworkServiceError.failedParsing))
				}
			case let .failure(error):
				self.completeOnMainQueue(completion, result: .failure(error))
			}
		}
	}
}

extension NetworkServiceManager {
	static func url(`for` baseURL:URL, path: String, parameters:JSONDictionary? = nil ) -> URL? {
		guard let pathComponents = URLComponents(string: path),
			var clientComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
			else {
				return nil
		}
		
		let clientPath = clientComponents.path
		if clientPath.isEmpty {
			let path = pathComponents.path.hasPrefix("/") ? pathComponents.path : "/" + pathComponents.path
			clientComponents.percentEncodedPath = path
		} else {
			let pathWithoutQuery = pathComponents.path
			clientComponents.percentEncodedPath = (URL(string: clientPath)?.appendingPathComponent(pathWithoutQuery).path)!
			if path.hasSuffix("/") {
				clientComponents.percentEncodedPath += "/"
			}
		}
		
		if let query = pathComponents.query {
			clientComponents.percentEncodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
		} else if let parameters = parameters {
			
			var parameterValueAllowed = CharacterSet.urlQueryAllowed
			parameterValueAllowed.remove(charactersIn: "&=?")
			
			clientComponents.percentEncodedQuery = parameters.flatMap({
				guard let value = "\($0.1)".addingPercentEncoding(withAllowedCharacters: parameterValueAllowed) else { return nil }
				return "\($0.0)=\(value)"}).joined(separator: "&")
		}
		
		return clientComponents.url
	}
}

private extension NetworkServiceManager {
	func completeOnMainQueue<A>(_ completion: @escaping (Alamofire.Result<A>) -> Void, result: Alamofire.Result<A>) {
		DispatchQueue.main.async {
			completion(result)
		}
	}
}
