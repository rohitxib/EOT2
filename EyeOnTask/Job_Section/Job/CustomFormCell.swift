//
//  CustomFormCell.swift
//  EyeOnTask
//
//  Created by Hemant-Aplite on 29/04/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit

class CustomFormCell: UITableViewCell {

    @IBOutlet weak var backgroundVw: UIView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var draftlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
