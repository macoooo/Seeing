//
//  SFBlindRoadViewController.swift
//  Seeing
//
//  Created by qiangshuting on 2021/3/21.
//

import UIKit
import MapKit
import CoreLocation

class SFBlindRoadViewController: UIViewController, CLLocationManagerDelegate {
    
    var mainMapView: MKMapView!
    
    //定位管理器
    let  locationManager: CLLocationManager = CLLocationManager()
    
    override  func  viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = .greatestFiniteMagnitude
        locationManager.requestWhenInUseAuthorization()
        //使用代码创建
        self.mainMapView =  MKMapView (frame: self.view.frame)
        self.view.addSubview( self.mainMapView)
        
        //地图类型设置 - 标准地图
        self .mainMapView.mapType = .standard
    }
    
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            mainMapView.showsUserLocation = true
        default:
            locationManager.stopUpdatingLocation()
            mainMapView.showsUserLocation = false
        }
    }
    
//    @available(iOS 4.2, 14.0)
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            mainMapView.showsUserLocation = true
        default:
            locationManager.stopUpdatingLocation()
            mainMapView.showsUserLocation = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        let latDelta = 0.01
        let longDelta = 0.01
        let currentLocationSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let currentRegion: MKCoordinateRegion = MKCoordinateRegion(center: location.coordinate, span: currentLocationSpan)
        
        //设置显示区域
        self.mainMapView.setRegion(currentRegion, animated: true)
        
        //创建一个大头针对象
        let  objectAnnotation = MKPointAnnotation()
        //设置大头针的显示位置
        objectAnnotation.coordinate = location.coordinate
        //设置点击大头针之后显示的标题
        objectAnnotation.title =  "南京夫子庙"
        //设置点击大头针之后显示的描述
        objectAnnotation.subtitle =  "南京市秦淮区秦淮河北岸中华路"
        //添加大头针
        self.mainMapView.addAnnotation(objectAnnotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位失败")
    }
}
