//
//  AddFlightTableViewCell.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/12/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit

class AddFlightTableViewCell: UITableViewCell {
    
    @IBOutlet weak var returnDate: UILabel!
    @IBOutlet weak var leaveDate: UILabel!
    @IBOutlet weak var origin: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var gate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
