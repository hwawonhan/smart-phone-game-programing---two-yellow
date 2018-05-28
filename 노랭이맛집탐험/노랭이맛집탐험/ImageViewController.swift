//
//  PagedScrollViewController.swift
//  ScrollView
//
//  Created by kpugame on 2018. 4. 9..
//  Copyright © 2018년 hwawonhan. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    var iiii: UIImage = UIImage(named: "photo2.png")!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string:"http://post.phinf.naver.net/MjAxNzAxMDhfMjc5/MDAxNDgzODg3MTkxNDMz.S53txrwXgtL9aU2SN4jhtaK3Yb1FgPFBoxTsvU8EM54g.512v347vrGjee5vsDaeTDLfnO_zxoBimkGj_pRMC7Xcg.JPEG/I-TWqDCDJ-JzDkBGDnY84vNx0PU0.jpg")
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
        
        //for index in lastPage + 1 ..< pageImages.count + 1{
        //    purgePage(index)
        //}
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        loadVisiblePages()
    }
}
