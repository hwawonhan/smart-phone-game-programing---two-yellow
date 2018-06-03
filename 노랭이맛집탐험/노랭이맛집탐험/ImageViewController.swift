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
    @IBOutlet weak var textview: UITextView!
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var linktitle = NSMutableString()
    var link = NSMutableString()
    
    var url: String = ""
    
    var location:String = ""
    var name:String = ""
    var adress:String = ""
    var category:String = ""
    var telephone:String = ""
    var roadadress:String = ""
    
    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    
    
    func beginParsing() {
        posts = []
        let api = "https://openapi.naver.com/v1/search/image.xml?query=\(self.location)\(self.name)&display=5&start=1&sort=random"
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
                self.parser = XMLParser(data: data!)
                self.parser.delegate = self
                self.parser.parse()
            }
        })
        task.resume()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName as NSString
        if ( elementName as NSString ).isEqual(to: "item") {
            elements = NSMutableDictionary()
            elements = [:]
            linktitle = NSMutableString()
            linktitle = ""
            link = NSMutableString()
            link = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if element.isEqual(to: "title")
        {
            linktitle.append(string)
        } else if element.isEqual(to: "link") {
            link.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        if (elementName as NSString).isEqual(to: "item"){
            if !linktitle.isEqual(nil) {
                elements.setObject(linktitle, forKey: "title" as NSCopying)
            }
            if !link.isEqual(nil) {
                elements.setObject(link, forKey: "link" as NSCopying)
            }
            posts.add(elements)
        }
        
    }
    
    
    
    func SettableviewData() {
        textview.text.append("가게이름")
        textview.text.append("\n")
        textview.text.append(name)
        textview.text.append("\n")
        textview.text.append("음식종류")
        textview.text.append("\n")
        textview.text.append(category)
        textview.text.append("\n")
        textview.text.append("전화번호")
        textview.text.append("\n")
        textview.text.append(telephone)
        textview.text.append("\n")
        textview.text.append("주소")
        textview.text.append("\n")
        textview.text.append(adress)
        textview.text.append("\n")
        textview.text.append("도로명주소")
        textview.text.append("\n")
        textview.text.append(roadadress)
        textview.text.append("\n")
        
    }
    
    func setimage() {
        let url = URL(string:"http://post.phinf.naver.net/MjAxNzAxMDhfMjc5/MDAxNDgzODg3MTkxNDMz.S53txrwXgtL9aU2SN4jhtaK3Yb1FgPFBoxTsvU8EM54g.512v347vrGjee5vsDaeTDLfnO_zxoBimkGj_pRMC7Xcg.JPEG/I-TWqDCDJ-JzDkBGDnY84vNx0PU0.jpg")
        //let url = URL(string: ((posts1.object(at: 0) as AnyObject).value(forKey: "link") as! String))
        if let data = try? Data(contentsOf: url!)
        {
            let image: UIImage = UIImage(data: data)!
            pageImages = [
                image,
                UIImage(named: "photo1")!,
                UIImage(named: "photo2")!,
                UIImage(named: "photo3")!,
                UIImage(named: "photo4")!
            ]
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SettableviewData()
        setimage()
        print((posts.object(at: 0) as AnyObject).value(forKey: "title") as! NSString as String)
        /*pageImages = [ UIImage(data: try! Data(contentsOf: URL(string: (posts.object(at: 0) as AnyObject).value(forKey: "link") as! String)!))!,
                       UIImage(data: try! Data(contentsOf: URL(string: (posts.object(at: 0) as AnyObject).value(forKey: "link") as! String)!))!,
                       UIImage(data: try! Data(contentsOf: URL(string: (posts.object(at: 0) as AnyObject).value(forKey: "link") as! String)!))!,
                       UIImage(data: try! Data(contentsOf: URL(string: (posts.object(at: 0) as AnyObject).value(forKey: "link") as! String)!))!,
                       UIImage(data: try! Data(contentsOf: URL(string: (posts.object(at: 0) as AnyObject).value(forKey: "link") as! String)!))!]
        setimage()
        pageImages = [
            UIImage(named: "photo1.png")!,
            UIImage(named: "photo2.png")!,
            UIImage(named: "photo3.png")!,
            UIImage(named: "photo4.png")!,
            UIImage(named: "photo5.png")!
        ]*/
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
