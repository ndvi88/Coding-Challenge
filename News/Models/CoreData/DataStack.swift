//
//  DataStack.swift
//  News
//
//  Created by vi nguyen on 12/11/17.
//  Copyright © 2017 com.vinguyen. All rights reserved.
//

import Foundation
import CoreData

enum DataStackStoreType: Int {
	case inMemory, sqLite
	
	var type: String {
		switch self {
		case .inMemory:
			return NSInMemoryStoreType
		case .sqLite:
			return NSSQLiteStoreType
		}
	}
}

class DataStack {
	private (set) var name: String
	private (set) var storeType: DataStackStoreType
	private (set) var managedObjectModel: NSManagedObjectModel
	
	lazy var viewContext: NSManagedObjectContext = {
		let coordinator = self.persistentStoreCoordinator
		var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		managedObjectContext.persistentStoreCoordinator = coordinator
		return managedObjectContext
	}()
	
	lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
		let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
		do {
			try self.addPersistentStoreForCoordinator(persistentStoreCoordinator, url: self.storeURL, type: self.storeType)
		} catch {
			
			// If create=ing coordinator fails, delete the store and try again
			_ = try? FileManager.default.removeItem(at: self.storeURL)
			
			do {
				try self.addPersistentStoreForCoordinator(persistentStoreCoordinator, url: self.storeURL, type: self.storeType)
			} catch {
				fatalError("Could not create data storage")
			}
		}
		return persistentStoreCoordinator
	}()
	
	init(name: String, managedObjectModel model: NSManagedObjectModel, storeType: DataStackStoreType) {
		self.name = name
		self.managedObjectModel = model
		self.storeType = storeType
	}
	
	convenience init(modelName: String, storeType: DataStackStoreType) {
		let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
		let model =  NSManagedObjectModel(contentsOf: modelURL)!
		self.init(name: modelName, managedObjectModel: model, storeType: storeType)
	}
}

private extension DataStack {
	var storeURL: URL {
		return DataStack.defaultDirectoryURL().appendingPathComponent("CoreData.sqlite.\(name)")
	}
	
	func addPersistentStoreForCoordinator(_ coordinator: NSPersistentStoreCoordinator, url: URL, type: DataStackStoreType) throws {
		let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
		try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
	}
	
	func deletePersistentStoreForCoordinator(_ coordinator: NSPersistentStoreCoordinator, type: DataStackStoreType) throws {
		guard let store = coordinator.persistentStores.first, let url = store.url else { return }
		
		let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
		try coordinator.destroyPersistentStore(at: url, ofType: store.type, options: options)
	}
	
	class func defaultDirectoryURL() -> URL {
		let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return urls.last!
	}
}
