//
//  MainViewModel.swift
//  News
//
//  Created by vi nguyen on 12/12/17.
//  Copyright © 2017 com.vinguyen. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

class MainViewModel:NSObject {
	private let newsManager: NewsManager
	private let dataManager: DataManager
	private let fetchResultsController: NSFetchedResultsController<News>
	var listOfNews = Variable<[NewsViewModel]>([])
	var loading = Variable<Bool>(false)
	var showAlert = PublishSubject<String>()
	var selectedNews:NewsViewModel?
	
	init(managerProvider: ManagerProvider = ManagerProvider.sharedInstance) {
		newsManager = managerProvider.newsManager
		dataManager = managerProvider.dataManager
		let fetchRequest = NSFetchRequest<News>(entityName: "News")
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
		fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataManager.dataStack.viewContext, sectionNameKeyPath: nil, cacheName: nil)
		super.init()
		fetchResultsController.delegate = self
	}
	
	func load(){
		loading.value = true
		try? fetchResultsController.performFetch()
		newsManager.loadNews(from: "bbc-sport") {[weak self] result in
			guard let `self` = self else { return }
			self.loading.value = false
			if case let .failure(error) = result {
				self.showAlert.onNext(error.localizedDescription)
			}
		}
	}
}

private extension MainViewModel {
	func updateNews() {
		let newsViewModels = fetchResultsController.fetchedObjects?.map { NewsViewModel(news: $0) }
		listOfNews.value = newsViewModels ?? []
	}
}

extension MainViewModel: NSFetchedResultsControllerDelegate {
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		updateNews()
	}
}
