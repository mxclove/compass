//
//  UIBarButtonItem+Extension.swift
//  私教中心
//
//  Created by 马超 on 15/9/22.
//  Copyright © 2015年 马超. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    class func itemWithTarget(target: AnyObject, action: Selector, image: String, selectedImage: String) -> UIBarButtonItem {
        let button = UIButton(type: UIButtonType.Custom)
        button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        button.setBackgroundImage(UIImage(named: image), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: selectedImage), forState: UIControlState.Highlighted)
        button.size((button.currentBackgroundImage?.size)!)
        return UIBarButtonItem(customView: button)
    }
}
