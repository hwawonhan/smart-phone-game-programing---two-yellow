//
//  PeekPagedScrollViewController.swift
//  ScrollView
//
//  Created by kpugame on 2018. 4. 10..
//  Copyright © 2018년 hwawonhan. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController , UIScrollViewDelegate, XMLParserDelegate {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet weak var telLabel: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var RoadLabel: UILabel!
    var myparser = XMLParser()
    var posts = NSMutableArray()
    var myelements = NSMutableDictionary()
    var element = NSString()
    var linktitle = NSMutableString()
    var mylink = NSMutableString()
    var audiocontroller:AudioController = AudioController()
    @IBOutlet weak var NOimageLabel: UILabel!
    var url: String = ""
    
    var location:String = ""
    var name:String = ""
    var adress:String = ""
    var category:String = ""
    var telephone:String = ""
    var roadadress:String = ""
    var mapx:String = ""
    var mapy:String = ""
    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    
    var myLocation = GeographicPoint()
    
    func beginParsing() {
        posts = []
        
        let api = "https://openapi.naver.com/v1/search/image.xml?query=\(location)\(name)&display=5&start=1&sort=sim"
        
        let encoding = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: encoding!)
        var request = URLRequest.init(url: url!)
        request.setValue("1qO9XJIT5mR1O3sz_u6J", forHTTPHeaderField: "X-Naver-Client-Id")
        request.setValue("bZcbo3uiSX", forHTTPHeaderField: "X-Naver-Client-Secret")
        request.httpMethod = "get"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            //error check
            guard error == nil && data != nil else {
                if let err = error {
                    print(err.localizedDescription)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.myparser = XMLParser(data: data!)
                self.myparser.delegate = self
                self.myparser.parse()
                self.setimage()
                if (self.pageImages.count <= 0)
                {
                    self.NOimageLabel.text = "이미지를 지원하지 않습니다."
                    self.NOimageLabel.isHidden = false
                }
                else {
                    self.NOimageLabel.isHidden = true
                }
            }
        })
        task.resume()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName as NSString
        if ( elementName as NSString ).isEqual(to: "item") {
            myelements = NSMutableDictionary()
            myelements = [:]
            linktitle = NSMutableString()
            linktitle = ""
            mylink = NSMutableString()
            mylink = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if element.isEqual(to: "title") {
            linktitle.append(string)
        } else if element.isEqual(to: "link") {
            mylink.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        if (elementName as NSString).isEqual(to: "item"){
            if !linktitle.isEqual(nil) {
                myelements.setObject(linktitle, forKey: "title" as NSCopying)
            }
            if !mylink.isEqual(nil) {
                myelements.setObject(mylink, forKey: "link" as NSCopying)
            }
            posts.add(myelements)
        }
        
    }
    
    
    @IBAction func ClickTelButton(_ sender: Any) {
        if(telephone != "")
        {
            audiocontroller.playerEffect(name: SoundDing)
            if let phoneCallURL = URL(string: "tel://\(telephone)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    func SettableviewData() {
        nameLabel.text = name
        categoryLabel.text = category
        telLabel.setTitle(telephone, for: .normal)
        locationLabel.text = adress
        RoadLabel.text = roadadress
        
    }
    
    func setimage() {
        for post in posts {
            if let url = URL(string: (post as AnyObject).value(forKey: "link") as! NSString as String) {
                if let data = try? Data(contentsOf: url)
                {
                    let image: UIImage = UIImage(data: data)!
                    self.pageImages.append(image)
                }
            }
        }
        let pageCount = self.pageImages.count
        self.pageControl.currentPage = 0
        self.pageControl.numberOfPages = pageCount
        
        for _ in 0..<pageCount {
            self.pageViews.append(nil)
        }
        
        let pageScrollViewSize = self.scrollView.frame.size
        self.scrollView.contentSize = CGSize(width: pageScrollViewSize.width * CGFloat(self.pageImages.count),
                                             height: pageScrollViewSize.height)
        
        self.loadVisiblePages()
    }
    
    @IBAction func doneToSelectViewController(segue:UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToMapView" {
            if let destination = segue.destination as? MapViewController {
                destination.mapX = self.mapx
                destination.mapY = self.mapy
                destination.cLocation = self.myLocation
            }
        }
    }
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginParsing()
        SettableviewData()
        audiocontroller.preloadAudioEffects(audioFileNames: AudioEffectFiles)
    }
    
    func loadPage (_ page: Int) {
        if page < 0 || page >= pageImages.count {
            return
        }
        
        if pageViews[page] != nil {
            
        } else {
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            frame = frame.insetBy(dx: 10.0, dy: 0.0)
            
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.contentMode = .scaleAspectFit
            newPageView.frame = frame
            scrollView.addSubview(newPageView)
            
            pageViews[page] = newPageView
        }
    }
    func purgePage(_ page:Int) {
        if page < 0 || page >= pageImages.count {
            return
        }
        
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    func loadVisiblePages(){
        let pageWidth = scrollView.frame.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        pageControl.currentPage = page
        
        let firstPage = page - 1
        let lastPage = page + 1
        
        for index in 0 ..< firstPage + 1 {
            purgePage(index)
        }
        
        for index in firstPage ... lastPage {
            loadPage(index)
        }
        
        if(self.pageImages.count > 0){
        for index in lastPage + 1 ..< self.pageImages.count + 1{
            purgePage(index)
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        loadVisiblePages()
    }
}
