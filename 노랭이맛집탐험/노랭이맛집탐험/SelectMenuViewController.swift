//
//  SelectMenuViewController.swift
//  노랭이맛집탐험
//
//  Created by kpugame on 2018. 5. 26..
//  Copyright © 2018년 hwawonhan. All rights reserved.
//

import UIKit
import CoreLocation

class SelectMenuViewController: UIViewController, CLLocationManagerDelegate{
    @IBOutlet weak var currentLocationText: UITextField!

    var locationManager : CLLocationManager!
    var sendlocation = "역곡동"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() //권한 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        let coor = locationManager.location?.coordinate
        
        //self.currentLocationText.text = String(describing: coor?.latitude)
        
        let findLocation = CLLocation(latitude: coor!.latitude, longitude: coor!.longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr") //원하는 언어의 나라 코드를 넣어주시면 됩니다.
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in if let address: [CLPlacemark] = placemarks { if var name: String = address.last?.name {
            name.removeFirst(6)
            
            self.currentLocationText.text = "현재위치:  " + name
            
            let search = "동"
            let range: Range<String.Index> = name.range(of: search)!
            let location = name.distance(from: name.startIndex, to: range.lowerBound)
            name.removeFirst(location - 3)
            self.sendlocation = String(name.components(separatedBy: ["1","2","3","4","5","6","7","8","9","0"]).joined())
            } //전체 주소
        }})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneToSelectViewController(segue:UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HansikSegueToTableView" {
            if let navController = segue.destination as? UINavigationController {
                    if let wordviewController = navController.topViewController as?
                    WordViewController {
                    wordviewController.location = self.sendlocation
                    wordviewController.foodtype = "한식"
                }
            }
        }
        if segue.identifier == "lisikSegueToTableView" {
            if let navController = segue.destination as? UINavigationController {
                if let wordviewController = navController.topViewController as?
                    WordViewController {
                    wordviewController.location = self.sendlocation
                    wordviewController.foodtype = "일식"
                }
            }
        }
        if segue.identifier == "jungsikSegueToTableView" {
            if let navController = segue.destination as? UINavigationController {
                if let wordviewController = navController.topViewController as?
                    WordViewController {
                    wordviewController.location = self.sendlocation
                    wordviewController.foodtype = "중식"
                }
            }
        }
        if segue.identifier == "cikienSegueToTable" {
            if let navController = segue.destination as? UINavigationController {
                if let wordviewController = navController.topViewController as?
                    WordViewController {
                    wordviewController.location = self.sendlocation
                    wordviewController.foodtype = "치킨"
                }
            }
        }
        if segue.identifier == "plzzaSegueToTableView" {
            if let navController = segue.destination as? UINavigationController {
                if let wordviewController = navController.topViewController as?
                    WordViewController {
                    wordviewController.location = self.sendlocation
                    wordviewController.foodtype = "피자"
                }
            }
        }
        if segue.identifier == "dsertSegueToTableView" {
            if let navController = segue.destination as? UINavigationController {
                if let wordviewController = navController.topViewController as?
                    WordViewController {
                    wordviewController.location = self.sendlocation
                    wordviewController.foodtype = "디저트"
                }
            }
        }
        if segue.identifier == "yasikSegueToTableView" {
            if let navController = segue.destination as? UINavigationController {
                if let wordviewController = navController.topViewController as?
                    WordViewController {
                    wordviewController.location = self.sendlocation
                    wordviewController.foodtype = "야식"
                }
            }
        }
        if segue.identifier == "bunsickSegueToTableView" {
            if let navController = segue.destination as? UINavigationController {
                if let wordviewController = navController.topViewController as?
                    WordViewController {
                    wordviewController.location = self.sendlocation
                    wordviewController.foodtype = "분식"
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
