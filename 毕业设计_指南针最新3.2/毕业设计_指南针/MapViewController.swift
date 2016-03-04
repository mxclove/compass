//
//  ViewController.swift
//  毕业设计_指南针
//
//  Created by 马超 on 15/10/26.
//  Copyright © 2015年 马超. All rights reserved.
//


import UIKit
import MapKit
import CoreData
import CoreLocation

var myLongitude = ""
var myLatitude = ""
var myAddress = ""

protocol MapViewControllerDelegate {
    func updataSelfLabels(controller: MapViewController)
}

class MapViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate, SwitchCellMapDelegate {

    var map = MKMapView()
//    var locationManager = CLLocationManager()
    var longitudeLabel = UILabel()
    var latitudeLabel = UILabel()
    var addressLabel = UILabel()
    var messageLabel = UILabel()
    let getUserLocationBTn = UIButton(type: UIButtonType.Custom)
    var currentLocation:CLLocation!
    var delegate : MapViewControllerDelegate?
    var updatingLocation = false
    let MATLABImageView = UIImageView()
    
    // 反地理编码管理器
    let geocorder = CLGeocoder()
    // 存储翻译过来的地址信息。（街道、门牌号等）
    var placemark: CLPlacemark?
    // 存储翻译时的错误
    var lastGeocodingError: NSError?
    // 判断是否正在执行反地理编码
    var performingReverseGeocoding = false
    // 存储NSError的对象
    var locationError: NSError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.frame = self.view.frame
        map.height(deviceHeight * 0.8)
        map.showsUserLocation = true
        map.mapType = MKMapType.Standard
        map.userTrackingMode = MKUserTrackingMode.FollowWithHeading
        map.delegate = self
        configureMapShouldDisplay()
        
        
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
        
        addressLabel.frame = CGRect(x: deviceWidth * 0.05, y: deviceHeight * 0.82, width: deviceWidth * 0.5, height: 30)
        
        addressLabel.textColor = UIColor.whiteColor()
        addressLabel.numberOfLines = 0
//        addressLabel.adjustsFontSizeToFitWidth = true
        addressLabel.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle
        addressLabel.text = "0"
        
        messageLabel.frame = CGRect(x: deviceWidth * 0.55, y: deviceHeight * 0.82, width: deviceWidth * 0.41, height: 30)
        
        messageLabel.textAlignment = NSTextAlignment.Right
        messageLabel.textColor = UIColor.whiteColor()
        messageLabel.text = "0"
        
//        MATLABImageView.frame = CGRect(x: deviceWidth - deviceWidth * 0.14 , y: 20, width: deviceWidth * 0.14, height: deviceWidth * 0.14)
//        MATLABImageView.image = UIImage(named: "MNT3")
        
        
        getUserLocationBTn.frame = CGRect(x: deviceWidth * 0.9, y: map.bounds.height * 0.85, width: deviceWidth * 0.1, height: deviceWidth * 0.1)
        
        getUserLocationBTn.addTarget(self, action: "showCurrectLocation", forControlEvents: UIControlEvents.TouchUpInside)
        
        getUserLocationBTn.setImage(UIImage(named: "icon_map"), forState: UIControlState.Normal)
        getUserLocationBTn.setImage(UIImage(named: "icon_map_highlighted"), forState: UIControlState.Highlighted)
        
        if modelStr == "iPhone" {
            longitudeLabel.font = UIFont.systemFontOfSize(17.0)
            latitudeLabel.font = UIFont.systemFontOfSize(17.0)
            addressLabel.font = UIFont.systemFontOfSize(20.0)
            messageLabel.font = UIFont.systemFontOfSize(13.0)
            addressLabel.adjustsFontSizeToFitWidth = true
            messageLabel.adjustsFontSizeToFitWidth = true
        } else if modelStr == "iPad" {
            longitudeLabel.font = UIFont.systemFontOfSize(25.0)
            latitudeLabel.font = UIFont.systemFontOfSize(25.0)
            addressLabel.font = UIFont.systemFontOfSize(32.0)
            messageLabel.font = UIFont.systemFontOfSize(20.0)
            addressLabel.adjustsFontSizeToFitWidth = false
        } else {
            longitudeLabel.font = UIFont.systemFontOfSize(17.0)
            latitudeLabel.font = UIFont.systemFontOfSize(17.0)
            addressLabel.font = UIFont.systemFontOfSize(20.0)
            messageLabel.font = UIFont.systemFontOfSize(13.0)
            addressLabel.adjustsFontSizeToFitWidth = true
            messageLabel.adjustsFontSizeToFitWidth = true
        }
        
//        self.view.addSubview(MATLABImageView)
        self.view.addSubview(longitudeLabel)
        self.view.addSubview(latitudeLabel)
        self.view.addSubview(addressLabel)
        self.view.addSubview(messageLabel)
        self.map.addSubview(getUserLocationBTn)
        
//        locationManager.delegate = self
//        
//        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        locationManager.startUpdatingLocation()

        
    }

    func configureMapShouldDisplay() {
        if trafficProtection == true && IJReachability.isConnectedToNetworkOfType() == .WWAN {
            self.map.removeFromSuperview()
        } else {
            self.view.addSubview(map)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showCurrectLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
//        currentLocation = locations.last
//        latitudeLabel.text = "纬度："+String(format: "%.1fº",Float (currentLocation.coordinate.latitude))
//        
//        longitudeLabel.text = "经度："+String(format: "%.1fº",Float (currentLocation.coordinate.longitude))
        
        currentLocation = CLLocation(latitude: map.userLocation.coordinate.latitude, longitude: map.userLocation.coordinate.longitude)
        updateLabels()
    }
    
// MARK: - CLLocationManagerDelegate Methods
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        // 处理地址信息获取错误的信息
        locationError = NSError(domain: "MyLocationError", code: 1, userInfo: nil)
        // 如果错误是地址不可知，则继续取地址信息
        if error.code == CLError.LocationUnknown.rawValue {
            return
        }
        locationError = error
//        print("location fail: \(error)")
        updateLabels()
    }
    
    func mapViewDidFailLoadingMap(mapView: MKMapView, withError error: NSError) {
        updatingLocation = false
        locationError = NSError(domain: "MyLocationError", code: 1, userInfo: nil)
        messageLabel.text = "DidFailLoadingMap"
        updateLabels()
        
    }
    
    func mapViewWillStartLoadingMap(mapView: MKMapView) {
        
        messageLabel.text = "WillStartLoadingMap"
        updateLabels()
    }
    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
        messageLabel.text = "DidFinishLoadingMap"
        updateLabels()
    }
    
    func mapViewWillStartLocatingUser(mapView: MKMapView) {
        messageLabel.text = "WillStartLocatingUser"
        updateLabels()
    }
    
//    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        self.map.removeFromSuperview()
//        self.view.addSubview(map)
//    }
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        // 得到以用户位置为中心的一片区域
        
//        latitudeLabel.text = "经度："+"\(map.userLocation.coordinate.longitude)"
//        longitudeLabel.text = "纬度："+"\(map.userLocation.coordinate.latitude)"
        messageLabel.text = "didUpdateUserLocation"
        currentLocation = CLLocation(latitude: map.userLocation.coordinate.latitude, longitude: map.userLocation.coordinate.longitude)
        
        
        let reigon = MKCoordinateRegionMakeWithDistance(map.userLocation.coordinate, 1000, 1000)
        map.setRegion(reigon, animated: true)
        geocorderDoWork()
        updateLabels()
    }
    
    func showCurrectLocation() {
        // 得到以用户位置为中心的一片区域
        let reigon = MKCoordinateRegionMakeWithDistance(map.userLocation.coordinate, 1000, 1000)
        map.setRegion(reigon, animated: true)
        currentLocation = CLLocation(latitude: map.userLocation.coordinate.latitude, longitude: map.userLocation.coordinate.longitude)
        updateLabels()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "授权", message: "请在设置中授权本软件获取您的位置信息", preferredStyle: UIAlertControllerStyle.Alert)
        
        let action = UIAlertAction(title: "好", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    private func showPlacemark(placemark: CLPlacemark) -> String {
        var line1 = ""
        line1.addText(placemark.subThoroughfare)
        line1.addText(placemark.thoroughfare)
        
        var line2 = ""
//        line2.addText(placemark.locality)
        line2.addText(placemark.locality, withseparator: " ")

        line2.addText(placemark.administrativeArea, withseparator: " ")
        line2.addText(placemark.postalCode, withseparator: " ")
        
        
        if line1.isEmpty {
            return line2
        } else {
            return line1 + line2
        }
        
    }
    
    func geocorderDoWork() {
        if !performingReverseGeocoding {
            performingReverseGeocoding = true
            
            geocorder.reverseGeocodeLocation(currentLocation!, completionHandler: { (placemarks, error) -> Void in
                
                self.lastGeocodingError = error
                
                if error == nil && !placemarks!.isEmpty {
                    
                    self.placemark = placemarks!.last
                }
                else {
                    self.placemark = nil
                }
                self.performingReverseGeocoding = false
                self.updateLabels()
            })
        }
    }
    
    private func updateLabels() {
        
        if let location = currentLocation {
            let long = String(format: "经度：%.5f ", location.coordinate.longitude)
            let lati = String(format: "纬度：%.5f", location.coordinate.latitude)
            longitudeLabel.text = long
            latitudeLabel.text = lati
            myLongitude = long
            myLatitude = lati
            
            addressLabel.text = ""
            
            if let placemark = placemark {
                let addr = showPlacemark(placemark)
                addressLabel.text = addr
                
            }
            else if performingReverseGeocoding {
                addressLabel.text = "搜寻地址中..."
            }
            else if lastGeocodingError != nil {
                addressLabel.text = "地址有错误"
                geocorderDoWork()
            }
            else {
                addressLabel.text = "没有这个地址"
            }
            if let str = addressLabel.text {
                myAddress = str
            }
            
        }
        else {
            
            longitudeLabel.text = ""
            latitudeLabel.text = ""
            addressLabel.text = ""
            
            var tempMessage = ""
            
            if let error = locationError {
                if error.domain == kCLErrorDomain && error.code == CLError.Denied.rawValue {
                    tempMessage = "地址服务不可用"
                }
                else {
                    tempMessage = "地址获取错误"
                }
            }
            else if !CLLocationManager.locationServicesEnabled() {
                tempMessage = "地址服务不可用"
                
            }
            else if updatingLocation {
                tempMessage = "搜寻中..."
            }
            else {
                tempMessage = "搜寻结束"
            }
            
            messageLabel.text = tempMessage
        }
        delegate?.updataSelfLabels(self)
    }

    
}












