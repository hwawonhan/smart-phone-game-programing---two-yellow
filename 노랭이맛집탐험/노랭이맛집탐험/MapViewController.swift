//
//  MapViewController.swift
//  노랭이맛집탐험
//
//  Created by kpugame on 2018. 6. 5..
//  Copyright © 2018년 hwawonhan. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, NMapViewDelegate, NMapPOIdataOverlayDelegate, XMLParserDelegate {
    var mapView: NMapView?
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var d = GeographicPoint()
    var lit = NSMutableString()
    var lat = NSMutableString()
    var location:String = ""
    
    
    var mapX:String = ""
    var mapY:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //beginParsing()
        mapView = NMapView(frame: self.view.frame)
        self.navigationController?.navigationBar.isTranslucent = false
        let convert = GeoConverter()
        let katecPoint = GeographicPoint(x: Double(mapX)!, y: Double(mapY)!)
        
        WHEN("Katec 좌표로 변환했을 때")
        let geoPoint = convert.convert(sourceType: .KATEC, destinationType: .WGS_84, geoPoint: katecPoint)
        
        //THEN("변환된 좌표가 x: 127.00000003159674, y: 38.000000111014 과 소숫점 8자리까지 일치해야 한다.")
        d = geoPoint!
        if let mapView = mapView {
            // set the delegate for map view
            mapView.delegate = self
            
            // set the application api key for Open MapViewer Library
            mapView.setClientId("1qO9XJIT5mR1O3sz_u6J")
                mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                
                view.addSubview(mapView)
        }
        mapView?.setBuiltInAppControl(true)
        
    }
    public func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        if (error == nil) { // success
            // set map center and level
            
            mapView.setMapCenter(NGeoPoint(longitude:d.x, latitude: d.y), atLevel:18)
            
            // set for retina display
            mapView.setMapEnlarged(true, mapHD: true)
        } else { // fail
            //print("onMapView:initHandler: \(error.description)")
        }
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForOverlayItem poiItem: NMapPOIitem!, selected: Bool) -> UIImage! {
        return NMapViewResources.imageWithType(poiItem.poiFlagType, selected: selected)
    }
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, anchorPointWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return NMapViewResources.anchorPoint(withType: poiFlagType)
    }
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, calloutOffsetWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return CGPoint(x: 0, y: 0)
    }
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForCalloutOverlayItem poiItem: NMapPOIitem!, constraintSize: CGSize, selected: Bool, imageForCalloutRightAccessory: UIImage!, calloutPosition: UnsafeMutablePointer<CGPoint>!, calloutHit calloutHitRect: UnsafeMutablePointer<CGRect>!) -> UIImage! {
        return nil
    }
    
    
}
