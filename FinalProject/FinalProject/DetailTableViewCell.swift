//
//  DetailTableViewCell.swift
//  FinalProject
//
//  Created by Linghao Du on 4/21/20.
//  Copyright © 2020 Linghao Du. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var purposeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
