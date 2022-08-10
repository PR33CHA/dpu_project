//
//  detailTableViewCell.swift
//  Vcare
//
//  Created by Preecha Jaruekklang on 22/12/2562 BE.
//  Copyright © 2562 dedodev. All rights reserved.
//

import UIKit

class detailTableViewCell: UITableViewCell {

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var shortTextLabel: UILabel! {
        didSet {
            shortTextLabel.numberOfLines = 0
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
