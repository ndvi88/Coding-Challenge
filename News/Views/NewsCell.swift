//
//  NewsCell.swift
//  News
//
//  Created by vi nguyen on 12/12/17.
//  Copyright © 2017 com.vinguyen. All rights reserved.
//

import UIKit
import Kingfisher

class NewsCell: UITableViewCell {
	@IBOutlet private weak var imgView: UIImageView!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var descriptionLabel: UILabel!
	@IBOutlet private weak var timeLabel: UILabel!
	
	func update(viewModel: NewsViewModel) {
		titleLabel.text = viewModel.title
		descriptionLabel.text = viewModel.descriptions
		timeLabel.text = viewModel.publishedAt
		if let imgURL = viewModel.urlToImage {
			imgView.kf.setImage(with: URL(string: imgURL))
		}
		
	}
	
}

// Mark - Overrides

extension NewsCell {
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		imgView.backgroundColor = .gray
	}
}
