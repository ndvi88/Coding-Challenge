//
//  NewsViewModel.swift
//  News
//
//  Created by vi nguyen on 12/12/17.
//  Copyright © 2017 com.vinguyen. All rights reserved.
//

import Foundation

class NewsViewModel:NSObject {
	var title: String?
	var descriptions: String?
	var url: String?
	var urlToImage: String?
	var publishedAt: String? = nil
	
	init(news:News) {
		title = news.title
		descriptions = news.descriptions
		url = news.url
		urlToImage = news.urlToImage
		let dateFotmatter: DateFormatter = {
			$0.dateFormat = "hh:mm - dd MMM, yyyy"
			$0.locale = Locale.current
			return $0
		}(DateFormatter())
		if let date = news.publishedAt as Date? {
			publishedAt = dateFotmatter.string(from: date)
		}
		
	}
	
}

