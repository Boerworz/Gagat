//
//  ArchiveTableCellView.swift
//  Gagat
//
//  Created by Tim Andersson on 2017-06-03.
//  Copyright © 2017 Cocoabeans Software. All rights reserved.
//

import UIKit

class ArchiveTableCellView: UITableViewCell {

	struct Style {
		let backgroundColor: UIColor
		let titleTextColor: UIColor
		let descriptionTextColor: UIColor

		static let light = Style(
			backgroundColor: .white,
			titleTextColor: .black,
			descriptionTextColor: UIColor(white: 0.4, alpha: 1.0)
		)

		static let dark = Style(
			backgroundColor: UIColor(white: 0.2, alpha: 1.0),
			titleTextColor: .white,
			descriptionTextColor: UIColor(white: 0.6, alpha: 1.0)
		)
	}

    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var artworkImageView: UIImageView?
	@IBOutlet private weak var descriptionLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        artworkImageView?.layer.cornerRadius = 10.0
    }

    func apply(style: Style) {
        backgroundColor = style.backgroundColor
        titleLabel?.textColor = style.titleTextColor
		descriptionLabel?.textColor = style.descriptionTextColor
    }

}
