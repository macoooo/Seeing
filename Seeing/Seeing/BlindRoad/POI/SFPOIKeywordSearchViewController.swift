//
//  SFPOIKeywordSearchViewController.swift
//  MAMapKit_2D_Demo
//
//  Created by xiaoming han on 16/9/23.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

import UIKit
import AMapSearchKit
import MAMapKit
import AMapFoundationKit
import RxSwift

class SFPOIKeywordSearchViewController: UIViewController, MAMapViewDelegate, AMapSearchDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate {

    var searchBar: UISearchBar!
    var search: AMapSearchAPI!
    var mapView: MAMapView!
    var customUserLocationView: MAAnnotationView!
    var viewModel: SFPOIKeywordSearchViewModel = SFPOIKeywordSearchViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.gray
        
        initMapView()
        initSearch()
        initSearchBar()
        
        let tipLabel = UILabel(frame: CGRect(x: self.view.frame.width - 150, y: 200, width: 150, height: 100))
        tipLabel.backgroundColor = .white
        self.view.addSubview(tipLabel)
        tipLabel.text = "欢迎大家\n长按某处道路上传盲道问题"
        tipLabel.textColor = .blue
        tipLabel.numberOfLines = 0
        tipLabel.textAlignment = .center
        tipLabel.layer.cornerRadius = 40
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 开启定位
        mapView.showsUserLocation = true
        mapView.customizeUserLocationAccuracyCircleRepresentation = true
        mapView.userTrackingMode = .follow
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func initMapView() {
        mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        mapView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
        self.view.addSubview(mapView)
    }
    
    func initSearch() {
        search = AMapSearchAPI()
        search.delegate = self
    }
    
    func initSearchBar() {
        searchBar = UISearchBar()
        searchBar.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        searchBar.delegate = self
        searchBar.placeholder = "请输入关键字"
        searchBar.sizeToFit()
        self.navigationItem.titleView = searchBar
    }
    
    @objc
    func longPress(gesture: UIGestureRecognizer) {
        if gesture.state == .ended {
            return
        }
        
//        let touchPoint = gesture.location(in: mapView)
//        let touchMapCoordinate: CLLocationCoordinate2D  = mapView.convert(touchPoint, to: mapView)
//        let pointAnnotation = MAPointAnnotation()
//        pointAnnotation.coordinate = touchMapCoordinate
//        mapView.addAnnotation(pointAnnotation)
    }
    //MARK: - Action
    
    func searchPOI(withKeyword keyword: String?) {
        
        if keyword == nil || keyword! == "" {
            return
        }
        
        let request = AMapPOIKeywordsSearchRequest()
        request.keywords = keyword
        request.requireExtension = true
        request.city = "北京"
        
        search.aMapPOIKeywordsSearch(request)
    }
    
    //MARK:- UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchPOI(withKeyword: searchBar.text)
    }
    
    //MARK: - MAMapViewDelegate
    func mapViewRequireLocationAuth(_ locationManager: CLLocationManager!) {
        locationManager.requestAlwaysAuthorization()
    }
    
    func mapView(_ mapView: MAMapView!, annotationView view: MAAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        print("name: \(String(describing: view.annotation.title))")
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAUserLocation.self) {
            let pointReuseIndetifier = "userLocationStyleReuseIndetifier"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
            
            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView?.image = UIImage(named: "userPosition")
            
            self.customUserLocationView = annotationView
            
            return annotationView!
        }

        if annotation.isKind(of: MAPointAnnotation.self) {
            guard let anno = annotation as? MAPointAnnotation else {
                return nil
            }
            if anno.isSearch {
                let pointReuseIndetifier = "searchPointReuseIndetifier"
                var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
                
                if annotationView == nil {
                    annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
                }
                
                annotationView!.canShowCallout = true
                annotationView!.isDraggable = false
                annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                return annotationView!
            } else {
                let pointReuseIndetifier = "pointReuseIndetifier"
                var annotationView: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
                
                if annotationView == nil {
                    annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
                }
                
                annotationView?.image = UIImage(named: "blindroad")
                annotationView?.centerOffset = CGPoint(x: 0, y: -18)
                return annotationView!
            }
        }
        
        return nil
    }
    
    func mapView(_ mapView: MAMapView!, didLongPressedAt coordinate: CLLocationCoordinate2D) {
        let request = AMapReGeocodeSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
        request.requireExtension = true
        search.aMapReGoecodeSearch(request)
    }
    
    //MARK: - AMapSearchDelegate
    
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        print("Error:\(String(describing: error))")
    }
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        
        mapView.removeAnnotations(mapView.annotations)
        
        if response.count == 0 {
            return
        }
        
        var annos = Array<MAPointAnnotation>()
        var selectAnno = MAPointAnnotation()
        for aPOI in response.pois {
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(aPOI.location.latitude), longitude: CLLocationDegrees(aPOI.location.longitude))
            let anno = MAPointAnnotation()
            anno.coordinate = coordinate
            anno.title = aPOI.name
            anno.subtitle = aPOI.address
            anno.isSearch = true
            annos.append(anno)
        }
        if let anno = annos.first {
            selectAnno = anno
        }
        viewModel.findRecentBlindRoad(latitude: selectAnno.coordinate.latitude, longitude: selectAnno.coordinate.longitude).subscribe { [weak self] (modelArray) in
            guard let self = self else {
                return
            }
            var annos = Array<MAPointAnnotation>()
            for model in modelArray {
                let anno = MAPointAnnotation()
                anno.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(model.latitude), longitude: CLLocationDegrees(model.longitude))
                anno.isSearch = false
                annos.append(anno)
            }
            self.mapView.addAnnotations(annos)
            self.mapView.showAnnotations(annos, animated: false)
        } onError: { (error) in
            print("获取用户个数错误\(error)")
        }.disposed(by: disposeBag)
        mapView.addAnnotations(annos)
        mapView.showAnnotations(annos, animated: false)
        mapView.selectAnnotation(annos.first, animated: true)
    }
    
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
     
        if response.regeocode == nil {
            return
        }
        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(request.location.latitude), longitude: CLLocationDegrees(request.location.longitude))
        let vc = SFAnnotationDetailViewController(coordinate: coordinate, reGeocode: response.regeocode)
        self.navigationController?.pushViewController(vc, animated: true)
        vc.doneBlock = { [weak self] in
            guard let self = self else {
                return
            }
            let anno = MAPointAnnotation()
            anno.coordinate = coordinate
            anno.title = response.regeocode.formattedAddress
            anno.isSearch = false
            self.mapView.addAnnotation(anno)
            self.mapView.selectAnnotation(anno, animated: false)
        }
    }
    
    func mapView(_ mapView:MAMapView!, rendererFor overlay:MAOverlay) -> MAOverlayRenderer! {
        if(overlay.isEqual(mapView.userLocationAccuracyCircle)) {
            let circleRender = MACircleRenderer.init(circle:mapView.userLocationAccuracyCircle)
            circleRender?.lineWidth = 2.0
            circleRender?.strokeColor = UIColor.lightGray
            circleRender?.fillColor = UIColor.red.withAlphaComponent(0.3)
            return circleRender
        }
        
        return nil
    }
    
    func mapView(_ mapView:MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation:Bool ) {
        if(!updatingLocation && self.customUserLocationView != nil) {
            UIView.animate(withDuration: 0.1, animations: {
                let degree = userLocation.heading.trueHeading - Double(self.mapView.rotationDegree)
                let radian = (degree * Double.pi) / 180.0
                self.customUserLocationView.transform = CGAffineTransform.init(rotationAngle: CGFloat(radian))
            })
        }
    }
}

extension MAPointAnnotation {
    private static var isSearchKey = false
    var isSearch: Bool {
        get {
            objc_getAssociatedObject(self, &Self.isSearchKey) as! Bool
        }
        set {
            objc_setAssociatedObject(self, &Self.isSearchKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
