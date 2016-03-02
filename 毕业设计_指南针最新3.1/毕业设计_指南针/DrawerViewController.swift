//
//  DrawerViewController.swift
//  毕业设计_指南针
//
//  Created by 马超 on 15/10/18.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit
let leftViewWidth: CGFloat = deviceWidth
let leftViewController = CompassViewController()
let mainViewController = MapViewController()

class DrawerViewController: UIViewController , UIGestureRecognizerDelegate{

    var leftView = UIView()
    var mainView = UIView()
    var isOpen = true
    
    var startX: CGFloat = 0.0
    let panGesture = UIPanGestureRecognizer()
    let pageControl = UIPageControl ()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)

        pageControl.frame = CGRect(x: deviceWidth * 0.5 - 20, y: deviceHeight * 0.92, width: 40, height: 37)
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        self.view.addSubview(pageControl)
        
        leftView.frame = self.view.frame
        leftView.backgroundColor = UIColor.redColor()
        leftViewController.view.frame = leftView.frame
        leftView = leftViewController.view
        self.view.addSubview(leftView)

        mainView.frame = self.view.frame
        mainView.backgroundColor = UIColor.greenColor()
        
        mainViewController.view.frame = CGRect(x: leftViewWidth, y: 0, width: deviceWidth, height: deviceHeight)
        mainView = mainViewController.view
        self.view.addSubview(mainView)
        
        
        mainViewController.delegate = leftViewController
        panGesture.addTarget(self, action: "panBegan:")
        panGesture.delegate = self
        self.view.addGestureRecognizer(panGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func figerOutNetworkOfType() {
        let statusType = IJReachability.isConnectedToNetworkOfType()
        switch statusType {
        case .WWAN:
//            print("Connection Type: Mobile")
            let alert = UIAlertController(title: "您正在使用流量上网,注意", message: "您可以进入设置，开启流量保护", preferredStyle: UIAlertControllerStyle.Alert)
            let Action = UIAlertAction(title: "好", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(Action)
            presentViewController(alert, animated: true, completion: nil)
        case .WiFi:
//            print("Connection Type: WiFi")
            break
        case .NotConnected:
            let alert = UIAlertController(title: "无法连接到网络，请检查您的网络", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            let Action = UIAlertAction(title: "好", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
                
            })
            
            alert.addAction(Action)
            presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    
    func panBegan(recongnizer: UIPanGestureRecognizer) {
    
//        let location = recongnizer.translationInView(self.view)
        
        let location = recongnizer.locationInView(self.view)
//        print(location.x)
        if recongnizer.state == UIGestureRecognizerState.Began {
            startX = location.x
        }
        
        var differX = location.x - startX
        
//        print("differX = \(differX)")
        if differX > leftViewWidth {
            differX = leftViewWidth
        }
        if differX < -leftViewWidth {
            differX = -leftViewWidth
        }
//
        if !isOpen {
            if borderAnimationEnable {
                if differX > 0 {
                    self.leftView.x(differX - leftViewWidth)
                    self.mainView.x(leftView.frame.origin.x + leftView.frame.width)
                } else {
                    self.leftView.x(differX * 0.3 - leftViewWidth)
                    self.mainView.x(leftView.frame.origin.x + leftView.frame.width)
                }
            } else {
                if differX > 0 {
                    self.leftView.x(differX - leftViewWidth)
                    self.mainView.x(leftView.frame.origin.x + leftView.frame.width)
                }
            }
            
            
            
        } else {
            if borderAnimationEnable {
                if differX < 0 {
                    self.leftView.x(differX)
                    self.mainView.x(leftView.frame.origin.x + leftView.frame.width)
                } else {
                    self.leftView.x(differX * 0.3)
                    self.mainView.x(leftView.frame.origin.x + leftView.frame.width)
                }
            } else {
                if differX < 0 {
                    self.leftView.x(differX)
                    self.mainView.x(leftView.frame.origin.x + leftView.frame.width)
                }
            }
            
            
        
        }
        
        if mainView.frame.origin.x < leftViewWidth * 0.5 {
            self.pageControl.currentPage = 1
        } else {
            self.pageControl.currentPage = 0
        }
        
//        if (differX + leftView.frame.origin.x) <= 0 && (differX + leftView.frame.origin.x) >= -leftView.frame.width {
//            self.leftView.x(differX - leftViewWidth)
//            self.mainView.x(leftView.frame.origin.x + leftView.frame.width)
//        }
       
        
        if recongnizer.state == UIGestureRecognizerState.Ended {
            
            if isOpen {
                if mainView.frame.origin.x < leftViewWidth * 0.8 {
                    UIView.animateWithDuration(0.5, delay: 0.01, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
                        self.leftView.x(-leftViewWidth)
                        self.mainView.x(0)
                        self.pageControl.currentPage = 1
                        self.mainView.userInteractionEnabled = true
                        self.isOpen = false
                        }, completion: nil)
                } else {
                    UIView.animateWithDuration(0.5, delay: 0.01, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
                        self.leftView.x(0)
                        self.mainView.x(leftViewWidth)
                        self.pageControl.currentPage = 0
                        self.mainView.userInteractionEnabled = false
                        self.isOpen = true
                        }, completion: nil)
                }
            } else {
                if mainView.frame.origin.x > leftViewWidth * 0.2 {
                    UIView.animateWithDuration(0.5, delay: 0.01, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
                        self.leftView.x(0)
                        self.mainView.x(leftViewWidth)
                        self.pageControl.currentPage = 0
                        self.mainView.userInteractionEnabled = false
                        self.isOpen = true
            
                        }, completion: nil)
                } else {
                    UIView.animateWithDuration(0.5, delay: 0.01, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
                        self.leftView.x(-leftViewWidth)
                        self.mainView.x(0)
                        self.pageControl.currentPage = 1
                        self.mainView.userInteractionEnabled = true
                        self.isOpen = false
                        }, completion: nil)
                }
            }
            
        }
        
    }


}

//extension DrawerViewController: MenuViewControllerDelegate {
//    func MenuSelectedControllerChanged(selectedNum: Int) {
//        mainViewController.view.frame = mainView.frame
//        mainView = mainViewController.view
//        mainView.userInteractionEnabled = false
//        self.view.addSubview(mainView)
//        
//        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
//            self.leftView.x(-leftViewWidth)
//            self.mainView.x(0)
//            }) { (finish) -> Void in
//            self.isOpen = false
//            self.mainView.userInteractionEnabled = true
//        }
//        
////        self.leftView.x(-leftViewWidth)
////        self.mainView.x(0)
////        self.isOpen = false
////        self.mainView.userInteractionEnabled = true
//        
//        print("self.view.subviews.count = === \(self.view.subviews.count)")
//    }
//}
