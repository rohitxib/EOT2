//
//  fifthTableViewCell.swift
//  EyeOnTask
//
//  Created by Mac on 05/09/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class fifthTableViewCell: UITableViewCell {
    @IBOutlet var btnSltDate: UIButton!
    
    @IBOutlet weak var H_trelingCelenderImg: NSLayoutConstraint!
    @IBOutlet weak var width_CelenderImg: NSLayoutConstraint!
    @IBOutlet var lbl_Ans: UILabel!
    @IBOutlet var lbl_Qstn: UILabel!
    @IBOutlet weak var numberlbl: UILabel!
    @IBOutlet var bgViewOFBtn: UIView!

    @IBOutlet weak var clockImg: UIImageView!
    @IBOutlet weak var celenderIng: UIImageView!
    var type = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
      
    }

    @IBAction func btnActionMethod(_ sender: Any) {
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
