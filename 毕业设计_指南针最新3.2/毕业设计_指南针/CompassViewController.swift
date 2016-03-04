//
//  ViewController.swift
//  毕业设计_指南针
//
//  Created by 马超 on 15/10/19.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation

let motionManager = CMMotionManager()
var locManager = CLLocationManager()
let zhiNanZhenImageWH = deviceWidth*0.9
let zhiNanZhenImagePointY = deviceHeight*0.04
let levelImageWH = zhiNanZhenImageWH*0.18
let shiImageWH = zhiNanZhenImageWH*0.38
let centerX = deviceWidth*0.5
let centerY = zhiNanZhenImagePointY+zhiNanZhenImageWH*0.5


class CompassViewController: UIViewController, MapViewControllerDelegate {

    var isOpen = false
    var angelLabel = UILabel()
    var zhiNanZhenImageView = UIImageView()
    var levelImageView = UIImageView()
    let verticalBarImageView = UIImageView()
//    let MATLABImageView = UIImageView()
    let shiImageView = UIImageView()
    var image = UIImage(named: "kd")
    var setBTn = UIButton(type: UIButtonType.Custom)
    var longitudeLabel = UILabel()
    var latitudeLabel = UILabel()
    var addressLabel = UILabel()
    var imageFlag = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let point = CGPoint(x: (deviceWidth - zhiNanZhenImageWH) * 0.5, y: zhiNanZhenImagePointY)
    
        zhiNanZhenImageView.frame = CGRect(origin: point, size: CGSize(width: zhiNanZhenImageWH, height: zhiNanZhenImageWH))
        zhiNanZhenImageView.image = image
        
        
//        print("modelStr +++++++++ %s ",modelStr)

//        shiImageView.frame.origin = CGPoint(x: deviceWidth * 0.5 - shiImageWH, y: centerY + shiImageWH)
//        shiImageView.frame.size = CGSize(width: shiImageWH, height: shiImageWH)
//
        shiImageView.frame = CGRect(x: (deviceWidth - shiImageWH) * 0.5 , y: centerY - shiImageWH * 0.5, width: shiImageWH, height: shiImageWH)
        shiImageView.image = UIImage(named: "shi2")
        
//        MATLABImageView.frame = CGRect(x: deviceWidth - deviceWidth * 0.14 , y: 20, width: deviceWidth * 0.14, height: deviceWidth * 0.14)
//        MATLABImageView.image = UIImage(named: "MNT3")
        
        
        let levelPoint = CGPoint(x: (deviceWidth - levelImageWH) * 0.5, y: zhiNanZhenImagePointY + (zhiNanZhenImageWH - levelImageWH) * 0.5)
        levelImageView.frame = CGRect(origin: levelPoint, size: CGSize(width: levelImageWH, height: levelImageWH))
        levelImageView.image = UIImage(named: "level_image")

        verticalBarImageView.frame = CGRect(x: deviceWidth * 0.5 - 1, y: zhiNanZhenImageWH * 0.174 + zhiNanZhenImagePointY - zhiNanZhenImageWH * 0.19, width: 2, height: zhiNanZhenImageWH * 0.19)
        verticalBarImageView.image = UIImage(named: "bg_list_m")
        
        
        self.view.addSubview(levelImageView)
        self.view.addSubview(shiImageView)
        self.view.addSubview(verticalBarImageView)
        self.view.addSubview(zhiNanZhenImageView)
//        self.view.addSubview(MATLABImageView)
        
        angelLabel.frame = CGRect(x: deviceWidth * 0.1, y: zhiNanZhenImageWH + zhiNanZhenImagePointY , width: deviceWidth * 0.3, height: deviceHeight * 0.2)
        angelLabel.textAlignment = NSTextAlignment.Right
        angelLabel.textColor = UIColor.whiteColor()
        angelLabel.text = "0º"
        
        
        longitudeLabel.frame = CGRect(x: deviceWidth * 0.1, y: deviceHeight * 0.9, width: deviceWidth * 0.4, height: 30)
        
//        longitudeLabel.contentMode = UIViewContentMode.Left
        longitudeLabel.textAlignment = NSTextAlignment.Left
        longitudeLabel.textColor = UIColor.whiteColor()
        longitudeLabel.text = "0"
        
        latitudeLabel.frame = CGRect(x: deviceWidth * 0.5, y: deviceHeight * 0.9, width: deviceWidth * 0.4, height: 30)
        
//        latitudeLabel.contentMode = UIViewContentMode.Right
        latitudeLabel.textAlignment = NSTextAlignment.Right
        latitudeLabel.textColor = UIColor.whiteColor()
        latitudeLabel.text = "0"
        
        addressLabel.frame = CGRect(x: deviceWidth * 0.3, y: deviceHeight * 0.82, width: deviceWidth * 0.6, height: 30)
        
        addressLabel.textColor = UIColor.whiteColor()
        addressLabel.numberOfLines = 0
        addressLabel.textAlignment = NSTextAlignment.Right
//        addressLabel.adjustsFontSizeToFitWidth = true
        addressLabel.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle
        addressLabel.text = "0"
        
        
        if modelStr == "iPhone" {
            longitudeLabel.font = UIFont.systemFontOfSize(17.0)
            latitudeLabel.font = UIFont.systemFontOfSize(17.0)
            addressLabel.font = UIFont.systemFontOfSize(20.0)
            addressLabel.adjustsFontSizeToFitWidth = true
            angelLabel.font = UIFont.systemFontOfSize(80.0)
        } else if modelStr == "iPad" {
            longitudeLabel.font = UIFont.systemFontOfSize(25.0)
            latitudeLabel.font = UIFont.systemFontOfSize(25.0)
            addressLabel.font = UIFont.systemFontOfSize(32.0)
            addressLabel.adjustsFontSizeToFitWidth = false
            angelLabel.font = UIFont.systemFontOfSize(100.0)
        } else {
            longitudeLabel.font = UIFont.systemFontOfSize(17.0)
            latitudeLabel.font = UIFont.systemFontOfSize(17.0)
            addressLabel.font = UIFont.systemFontOfSize(20.0)
            addressLabel.adjustsFontSizeToFitWidth = true
            angelLabel.font = UIFont.systemFontOfSize(80.0)
        }
        
        
        
        
        self.view.addSubview(angelLabel)
        configureSelf()
        locManager.delegate = self
        
        if CLLocationManager.headingAvailable() {
            locManager.startUpdatingHeading()
        } else {
            print("不可用")
        }
        
        setBTn.frame = CGRect(x: deviceWidth * 0.05, y: deviceWidth * 0.05, width: deviceWidth * 0.15, height: deviceWidth * 0.15)
        
        setBTn.addTarget(self, action: "setBTnChecked", forControlEvents: UIControlEvents.TouchUpInside)
//        setBTn.addTarget(self, action: "setBackgrand", forControlEvents: UIControlEvents.TouchUpOutside)
        
        setBTn.setImage(UIImage(named: "setting"), forState: UIControlState.Normal)

        self.view.addSubview(setBTn)
        showdata()
    }
    
    
    func setBTnChecked() {
        
//        settingController =  storyboard!.instantiateViewControllerWithIdentifier("setting") as? settingViewController
        
        let setController = setTableViewController()
        let nav = UINavigationController(rootViewController: setController)
        setController.navigationItem.leftBarButtonItem = UIBarButtonItem.itemWithTarget(self, action: "dismissSelf", image: "adsmogo_button_left_default", selectedImage: "adsmogo_button_left_disabled")

        presentViewController(nav, animated: true, completion: nil)
        
    }
    
//    func setBackgrand() {
//        
//        if imageFlag == 0 {
//            self.image = UIImage(named: "kd")
//            
//            imageFlag = 1
//        } else if imageFlag == 1{
//            self.image = UIImage(named: "compass_under11")
//            imageFlag = 0
//        }
//        self.zhiNanZhenImageView.reloadInputViews()
//    }
    
    
    func dismissSelf() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showdata() {
        if !motionManager.deviceMotionAvailable {
            print("Device motion not availabel")
        }
        
        motionManager.deviceMotionUpdateInterval = 0.1
        
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue()!) { (data, error) -> Void in
            
            let pitch = data?.attitude.pitch // x
            let roll = data?.attitude.roll // y
//            let yaw = data?.attitude.yaw // z
            
//            self.pitchLabel.text = String(format: "%.2f", pitch!)
//            self.rollLabel.text = String(format: "%.2f", roll!)
//            self.yawLabel.text = String(format: "%.2f", yaw!)
            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                
                self.levelImageView.center.x = centerX + CGFloat(-roll! * 100)
                self.levelImageView.center.y = centerY + CGFloat(-pitch! * 100)
                
                }, completion: nil)
            
            
        }
    }


    
    func showmagnetometerdata() {
        if !motionManager.magnetometerAvailable {
            print("Device motion not availabel")
        }
        
        motionManager.magnetometerUpdateInterval = 0.2
        motionManager.startMagnetometerUpdatesToQueue(NSOperationQueue.currentQueue()!) { (data, error) -> Void in
            
            let pitch = (data?.magneticField.x)!// x
            let roll = (data?.magneticField.y)!// y
            let yaw = (data?.magneticField.z)! // z
            
            let final = sqrt(pitch*pitch + roll*roll + yaw*yaw)
            self.angelLabel.text = String(format: "%.f",final)
//            self.pitchLabel.text = String(format: "%.2f特斯拉", pitch)
//            self.rollLabel.text = String(format: "%.2f特斯拉", roll)
//            self.yawLabel.text = String(format: "%.2f特斯拉", yaw)
            
//            self.rotateImage(CGFloat(yaw))
        }
    }
    

//    func rotateImage(rotation:CGFloat){
//        
//    // 对图片进行旋转
//    self.zhiNanZhenImageView.transform=CGAffineTransformMakeRotation(rotation)
//    
//    }
    
    
}

extension CompassViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didFailWithError = %@",error)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        let heading:CGFloat = CGFloat(-1.0 * M_PI * newHeading.magneticHeading/180.0
)
        self.angelLabel.text = String(format: "%.fº",newHeading.magneticHeading)
        
        UIView.animateKeyframesWithDuration(0.22, delay: 0.02, options: UIViewKeyframeAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            self.zhiNanZhenImageView.transform = CGAffineTransformMakeRotation(heading)
            
            }, completion: nil)
        
    }
    func locationManagerShouldDisplayHeadingCalibration(manager: CLLocationManager) -> Bool {
        return true
    }
    
}


extension CompassViewController {
    func updataSelfLabels(controller: MapViewController) {
        self.latitudeLabel.text = myLatitude
        self.longitudeLabel.text = myLongitude
        self.addressLabel.text = myAddress
    }
}

extension CompassViewController: SwitchCellDelegate {
    func configureSelf() {
        if compassViewShouldShowLocation {
            self.view.addSubview(longitudeLabel)
            self.view.addSubview(latitudeLabel)
            self.view.addSubview(addressLabel)
        } else {
            self.latitudeLabel.removeFromSuperview()
            self.longitudeLabel.removeFromSuperview()
            self.addressLabel.removeFromSuperview()
        }
    }
}

