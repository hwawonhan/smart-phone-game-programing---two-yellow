//
//  PeekPagedScrollViewController.swift
//  ScrollView
//
//  Created by kpugame on 2018. 4. 10..
//  Copyright © 2018년 hwawonhan. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController , UIScrollViewDelegate {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet weak var mydata: UITableView!
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var link = NSMutableString()
    
    var location:String = ""
    
    var name:String = ""
    var adress:String = ""
    var category:String = ""
    var telephone:String = ""
    var roadadress:String = ""
    var myindex:Int = 1
    
    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    func beginParsing()
    {
        posts = []
        let api = "https://openapi.naver.com/v1/search/image.xml?query=\(location)\(name)&display=5&start=1&sort=random"
        let encoding = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: encoding!)
        print(api)
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
                self.parser = XMLParser(data: data!)
                self.parser.parse()
            }
        })
        task.resume()
        
    }
    
    
    
    
    func parser(_ parser: XMLParser, didStartElement elementName:
        String, namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String : String])
    {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "item")
        {
            elements = NSMutableDictionary()
            elements = [:]
            link = NSMutableString()
            link = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if element.isEqual(to: "link") {
            link.append(String(string.components(separatedBy: ["<",">","b","/"]).joined()))
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        
        if (elementName as NSString).isEqual(to: "item") {
            if !name.isEqual(nil) {
                elements.setObject(name, forKey: "link" as NSCopying)
            }
            posts.add(elements)
        }
    }
    
    func loadInitData() {
        name = (posts.object(at: myindex) as AnyObject).value(forKey: "title") as! NSString as String
        adress = (posts.object(at: myindex) as AnyObject).value(forKey: "address") as! NSString as String
        category = (posts.object(at: myindex) as AnyObject).value(forKey: "category") as! NSString as String
        telephone = (posts.object(at: myindex) as AnyObject).value(forKey: "telephone") as! NSString as String
        roadadress = (posts.object(at: myindex) as AnyObject).value(forKey: "roadAddress") as! NSString as String
        print(name)
    }
    
    func SettableviewData() {
       
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitData()
        beginParsing()
        SettableviewData()
        pageImages = [ UIImage(named: "photo1.png")!,
                       UIImage(named: "photo2.png")!,
                       UIImage(named: "photo3.png")!,
                       UIImage(named: "photo4.png")!,
                       UIImage(named: "photo5.png")!]
        
        let pageCount = pageImages.count
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        let pageScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: pageScrollViewSize.width * CGFloat(pageImages.count),
                                        height: pageScrollViewSize.height)
        
        loadVisiblePages()
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
        
        for index in lastPage + 1 ..< pageImages.count + 1{
            purgePage(index)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        loadVisiblePages()
    }
}
