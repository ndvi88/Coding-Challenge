//
//  News.swift
//  News
//
//  Created by vi nguyen on 12/11/17.
//  Copyright © 2017 com.vinguyen. All rights reserved.
//
import Foundation
import CoreData

extension News {
	convenience init(dictionary: JSONDictionary, context: NSManagedObjectContext) {
		self.init(context: context)
		self.descriptions = dictionary["description"] as? String
		self.title = dictionary["title"] as? String
		self.url = dictionary["url"] as? String
		self.urlToImage = dictionary["urlToImage"] as? String
		if let dateString = dictionary["publishedAt"] as? String {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
			dateFormatter.locale = Locale.current
			let date = dateFormatter.date(from: dateString)
			self.publishedAt = date as NSDate?
		}
	}
}
