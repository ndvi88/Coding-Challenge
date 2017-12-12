//
//  MainViewController.swift
//  News
//
//  Created by vi nguyen on 12/11/17.
//  Copyright © 2017 com.vinguyen. All rights reserved.
//

import UIKit
import RxSwift

class MainViewController: UITableViewController {
	private let disposeBag = DisposeBag()
	private let viewModel:MainViewModel = MainViewModel()
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 120
		tableView.refreshControl = UIRefreshControl()
		tableView.tableFooterView = UIView()
		refreshControl?.addTarget(self, action: #selector(updateNews), for: .valueChanged)
		viewModel.loading.asObservable().subscribe(onNext: { [weak self] loading in
			if loading {
				if !(self?.refreshControl?.isRefreshing ?? false) {
					self?.view.isUserInteractionEnabled = false
					self?.refreshControl?.beginRefreshing()
				}
				
			} else {
				self?.view.isUserInteractionEnabled = true
				self?.refreshControl?.endRefreshing()
			}
			
		}).disposed(by: disposeBag)
		
		viewModel.listOfNews.asObservable().subscribe { [weak self] _ in
			self?.tableView.reloadData()
			}.disposed(by: disposeBag)
		
		viewModel.showAlert.subscribe(onNext: {[weak self] message in
			self?.showInfoAlert(message, title: NSLocalizedString("Error", comment: ""), completion: nil)
		}).disposed(by: disposeBag)
		
		viewModel.load()
	}
	
}
extension MainViewController {
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.listOfNews.value.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell else {
			return UITableViewCell()
		}
		let news = viewModel.listOfNews.value[indexPath.row]
		cell.update(viewModel: news)
		return cell
	}
	
}

private extension MainViewController {
	@objc func updateNews(){
		viewModel.load()
	}
}
