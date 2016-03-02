//
//  detailCell.swift
//  毕业设计_指南针
//
//  Created by MC on 15/12/9.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

class detailCell: UITableViewCell {

    @IBOutlet weak var rightLabel: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.selectionStyle = UITableViewCellSelectionStyle.Default
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
