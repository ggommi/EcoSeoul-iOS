//
//  DonationListTVCell.swift
//  EcoSeoul
//
//  Created by 조예은 on 2018. 9. 21..
//  Copyright © 2018년 GGOMMI. All rights reserved.
//

import UIKit

class DonationListTVCell: UITableViewCell {

    @IBOutlet weak var orgNameLB: UILabel!
    @IBOutlet weak var mileageDateLB: UILabel!
    @IBOutlet weak var mileageWithDrawLB: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
