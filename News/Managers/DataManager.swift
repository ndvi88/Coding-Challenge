//
//  DataManager.swift
//  News
//
//  Created by vi nguyen on 12/11/17.
//  Copyright © 2017 com.vinguyen. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
	private (set) var dataStack: DataStack
	private let modelName: String
	private let storeType: DataStackStoreType
	
	init(modelName: String = "SportNews", storeType: DataStackStoreType = .sqLite) {
		self.modelName = modelName
		self.storeType = storeType
		self.dataStack = DataStack(modelName:modelName, storeType: storeType)
	}
	
	func saveContext() {
		do {
			try dataStack.viewContext.save()
		} catch let error {
			assertionFailure(error.localizedDescription)
		}
	}
	
	func clearDataBase() {
		guard let persistentStoreCoordinator = dataStack.viewContext.persistentStoreCoordinator else {
			return
		}
		dataStack.viewContext.reset()
		persistentStoreCoordinator.performAndWait {
			let stores = persistentStoreCoordinator.persistentStores
			
			for store in stores {
				if let path = store.url?.path {
					do {
						try persistentStoreCoordinator.remove(store)
						try FileManager.default.removeItem(atPath: path)
					} catch let error {
						print("Cannot clear database. Error: \(error)")
					}
				}
			}
		}
		self.dataStack = DataStack(modelName:modelName, storeType: storeType)
	}
	
	func fetchEntity<T: NSManagedObject>(_ entity: T.Type, predicate: NSPredicate? = nil) -> [T]? {
		let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entity))
		fetchRequest.predicate = predicate
		var objects: [T]?
		dataStack.viewContext.performAndWait {
			do {
				objects = try dataStack.viewContext.fetch(fetchRequest)
			} catch let error as NSError {
				print("Error fetch data: \(error.localizedDescription)")
			}
		}
		return objects
	}
	
	func deleteWithEntity<T: NSManagedObject>(_ entity: T.Type, predicate: NSPredicate? = nil) {
		let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: entity))
		fetch.predicate = predicate
		let result = try? dataStack.viewContext.fetch(fetch)
		let resultData = result as! [T]
		for object in resultData {
			dataStack.viewContext.delete(object)
		}
	}
	
}
