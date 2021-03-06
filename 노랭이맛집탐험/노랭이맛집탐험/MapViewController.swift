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
    
    @IBOutlet weak var type: UISegmentedControl!
    var cLocation = GeographicPoint()
    var mapX:String = ""
    var mapY:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type.selectedSegmentIndex = 0
        //beginParsing()
        mapView = NMapView(frame: self.view.frame)
        self.navigationController?.navigationBar.isTranslucent = false
        let convert = GeoConverter()
        let katecPoint = GeographicPoint(x: Double(mapX)!, y: Double(mapY)!)
        
        WHEN("Katec 좌표로 변환했을 때")
        let geoPoint = convert.convert(sourceType: .KATEC, destinationType: .WGS_84, geoPoint: katecPoint)
        d = geoPoint!
        if let mapView = mapView {
            // set the delegate for map view
            mapView.delegate = self
            
            // set the application api key for Open MapViewer Library
            mapView.setClientId("1qO9XJIT5mR1O3sz_u6J")
                mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
                view.addSubview(mapView)
        }
        mapView?.setBuiltInAppControl(false)
        marker()
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        // 12
        switch type.selectedSegmentIndex {
            
        case 0:
            self.mapView?.mapViewMode = .vector
        case 1:
            self.mapView?.mapViewMode = .hybrid
        default:
            ()
            
        }
        //onMapView(mapView, initHandler: nil)
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
    func marker () {
        
            
            if let mapOverlayManager = mapView?.mapOverlayManager {
                
                // create POI data overlay
                if let poiDataOverlay = mapOverlayManager.newPOIdataOverlay() {
                    
                    poiDataOverlay.initPOIdata(2)
                    
                    poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: d.x, latitude: d.y), title: "Touch & Drag to Move", type: UserPOIflagTypeDefault, iconIndex: 0, with: nil)
                    poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: cLocation.x, latitude: cLocation.y), title: "099", type: NMapPOIflagTypeLocation, iconIndex: 0, with: nil)
                    
                    poiDataOverlay.endPOIdata()
                    
                    // select item
                    poiDataOverlay.selectPOIitem(at: 0, moveToCenter: true)
                    
                    // show all POI data
                    poiDataOverlay.showAllPOIdata()
                }
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
