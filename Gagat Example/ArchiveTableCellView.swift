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
		var backgroundColor: UIColor
		var textColor: UIColor

		static let light = Style(
			backgroundColor: .white,
			textColor: .black
		)

		static let dark = Style(
			backgroundColor: UIColor(white: 0.2, alpha: 1.0),
			textColor: .white
		)
	}

    @IBOutlet fileprivate weak var label: UILabel?
    @IBOutlet fileprivate weak var artworkImageView: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        artworkImageView?.layer.cornerRadius = 10.0
    }

    func apply(style: Style) {
        backgroundColor = style.backgroundColor
        label?.textColor = style.textColor
    }

}
