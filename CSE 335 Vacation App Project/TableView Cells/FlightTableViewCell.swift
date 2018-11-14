//
//  FlightTableViewCell.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/13/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit

class FlightTableViewCell: UITableViewCell {
    
    @IBOutlet weak var flightLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var flightPic: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
