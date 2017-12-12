//
//  News+CoreDataProperties.swift
//  News
//
//  Created by vi nguyen on 12/12/17.
//  Copyright © 2017 com.vinguyen. All rights reserved.
//
//

import Foundation
import CoreData


extension News {
	
    @NSManaged public var descriptions: String?
    @NSManaged public var publishedAt: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?

}
