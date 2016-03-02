//
//  setTableViewController.swift
//  毕业设计_指南针
//
//  Created by MC on 15/12/9.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

class setTableViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibtextCell = UINib(nibName: "switchSetCell", bundle: nil)
        tableView.registerNib(nibtextCell, forCellReuseIdentifier: "switchcell")
        
        let nibsetCell = UINib(nibName: "setCell", bundle: nil)
        tableView.registerNib(nibsetCell, forCellReuseIdentifier: "settingCell")
        
        let nibdetailCell = UINib(nibName: "detailCell", bundle: nil)
        tableView.registerNib(nibdetailCell, forCellReuseIdentifier: "detailcell")

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("switchcell") as! switchSetCell
            
            cell.nameLabel?.text = "流量保护"
            cell.mySwitch.on = trafficProtection
            if cell.delegate == nil {
                cell.delegate = leftViewController
                cell.delegateMap = mainViewController
            }
            return cell
//        case 1:
//            cell.nameLabel?.text = "显示位置信息"
//            cell.mySwitch.on = compassViewShouldShowLocation
//            if cell.delegate == nil {
//                cell.delegate = leftViewController
//                cell.delegateMap = mainViewController
//            }
//            return cell
//            
//        case 2:
//            cell.nameLabel?.text = "边界滑动效果"
//            cell.mySwitch.on = borderAnimationEnable
//            return cell
//            
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("switchcell") as! switchSetCell
            
            cell.nameLabel?.text = "屏幕常亮"
            cell.mySwitch.on = UIApplication.sharedApplication().idleTimerDisabled
            return cell

            
            
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("detailcell") as! detailCell
            cell.nameLabel?.text = "指南针使用帮助"
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("settingCell") as! setCell
            cell.rightLabel?.text = "986455470@qq.com"
            cell.nameLabel?.text = "联系我们"
            return cell
         
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("settingCell") as! setCell
            
            cell.nameLabel?.text = "test"
            return cell
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 {
            
        let alert = UIAlertController(title: "指南针使用帮助", message: "请尽量远离磁场干扰，指南针方向更准确。“附近可能有磁场干扰”需要校准时，会自动激活校准界面，请按照提示操作。\r\r获取详细位置信息需要网络连接。", preferredStyle: UIAlertControllerStyle.Alert)
        let Action = UIAlertAction(title: "好", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(Action)
        presentViewController(alert, animated: true, completion: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
    }
    
    
//    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        switch section {
//        case 0: return "移动数据联网情况下，不加载地图"
//        case 1: return "在指南针界面显示位置和经纬度信息"
//        case 2: return "允许边界被滑动"
//        case 3: return "开启此开关，则屏幕常亮"
//        default: return ""
//            
//        }
//    }
}