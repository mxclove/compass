//
//  UIVIew_Extension.swift
//  私教中心
//
//  Created by 马超 on 15/10/12.
//  Copyright © 2015年 马超. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func x(x: CGFloat) {
        var frame = self.frame
        frame.origin.x = x
        self.frame = frame
    }
    
    func y(y: CGFloat) {
        var frame = self.frame
        frame.origin.y = y
        self.frame = frame
    }
    
    func width(width: CGFloat) {
        var frame = self.frame
        frame.size.width = width
        self.frame = frame
    }
    
    func height(height: CGFloat) {
        var frame = self.frame
        frame.size.height = height
        self.frame = frame
    }
    
    func size(size: CGSize) {
        var frame = self.frame
        frame.size = size
        self.frame = frame
    }
    
    func origin(origin: CGPoint) {
        var frame = self.frame
        frame.origin = origin
        self.frame = frame
    }
    
    func centerX(x: CGFloat) {
        var center = self.center
        center.x = x
        self.center = center
    }
    
    func centerY(y: CGFloat) {
        var center = self.center
        center.y = y
        self.center = center
    }
    
//    class func itemWithTarget(title: String, target: AnyObject, action: Selector, leftImage: String, leftSelectedImage: String,tag: Int, parentView: UIView) -> UIButton {
//        
//        let button = UIButton()
//        button.tag = tag
//        button.frame = CGRect(x: 0, y: 0, width: parentView.frame.width, height: parentView.frame.height)
//        button.setTitle(title, forState: UIControlState.Normal)
//        button.titleLabel?.font = UIFont.systemFontOfSize(12)
//        button.titleLabel?.textAlignment = NSTextAlignment.Left
//        button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
//        button.setTitleColor(UIColor(red: 226/255, green: 81/255, blue: 132/255, alpha: 1.0), forState: UIControlState.Selected)
//        button.setTitleColor(UIColor(red: 226/255, green: 81/255, blue: 132/255, alpha: 1.0), forState: UIControlState.Highlighted)
//        
//        button.imageView?.contentMode = UIViewContentMode.Center
//        button.setImage(UIImage(named: leftImage), forState: UIControlState.Normal)
//        button.setImage(UIImage(named: leftSelectedImage), forState: UIControlState.Selected)
//        button.setImage(UIImage(named: leftSelectedImage), forState: UIControlState.Highlighted)
//        
//        
//        
//        button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
//        
//        button.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, parentView.frame.width*0.7)
//        button.titleEdgeInsets = UIEdgeInsetsMake(4, 4, 4, parentView.frame.width*0.5)
//        
//        parentView.addSubview(button)
//        
//        return button
//    }
    
    
    
    
    
    
}
