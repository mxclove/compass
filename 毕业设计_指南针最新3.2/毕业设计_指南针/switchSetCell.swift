//
//  switchSetCell.swift
//  毕业设计_指南针
//
//  Created by MC on 16/2/20.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate {
    func configureSelf()
}
protocol SwitchCellMapDelegate {
    func configureMapShouldDisplay()
}

class switchSetCell: UITableViewCell {

    
    var delegateMap : SwitchCellMapDelegate?
    var delegate: SwitchCellDelegate?
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var mySwitch: UISwitch!
    
    @IBAction func mySwitchChecked(sender: UISwitch) {
        
        if self.nameLabel.text == "流量保护" {
            trafficProtection = mySwitch.on
            NSUserDefaults.standardUserDefaults().setBool(mySwitch.on, forKey: "trafficProtection")
            delegateMap?.configureMapShouldDisplay()
        } else if self.nameLabel.text == "显示位置信息" {
            compassViewShouldShowLocation = mySwitch.on
            NSUserDefaults.standardUserDefaults().setBool(mySwitch.on, forKey: "compassViewShouldShowLocation")
            delegate?.configureSelf()
        } else if self.nameLabel.text == "边界滑动效果" {
            borderAnimationEnable = mySwitch.on
            NSUserDefaults.standardUserDefaults().setBool(mySwitch.on, forKey: "borderAnimationEnable")
        } else if self.nameLabel.text == "屏幕常亮" {
            UIApplication.sharedApplication().idleTimerDisabled = mySwitch.on
            NSUserDefaults.standardUserDefaults().setBool(mySwitch.on, forKey: "idleTimerDisabled")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
