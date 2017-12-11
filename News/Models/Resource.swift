//
//  Resource.swift
//  News
//
//  Created by vi nguyen on 12/11/17.
//  Copyright © 2017 com.vinguyen. All rights reserved.
//

import Foundation
import Alamofire

public typealias JSONDictionary = [String: Any]
public typealias JSONArray = [Any]

struct Resource<A> {
	let url: URL
	let method: Alamofire.HTTPMethod
	let parse: (Data) -> A?
	let parameters: JSONDictionary?
	let headers: [String: String]?
}

extension Resource {
	init(url: URL, parameters: JSONDictionary? = nil, headers: [String: String]? = nil, method: Alamofire.HTTPMethod = .get, parseJSON: @escaping (Any) -> A?) {
		self.url = url
		self.method = method
		self.parse = { data in
			let json = try? JSONSerialization.jsonObject(with: data, options: [])
			return json.flatMap(parseJSON)
		}
		self.parameters = parameters
		self.headers = headers
	}
}
