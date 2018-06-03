//
//  ScrollViewContainr.swift
//  노랭이맛집탐험
//
//  Created by kpugame on 2018. 6. 4..
//  Copyright © 2018년 hwawonhan. All rights reserved.
//

import UIKit

class ScrollViewContainr: UIView {
    @IBOutlet var scrollView: UIScrollView!
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if let theView = view {
            if theView == self {
                return scrollView
            }
        }
        return view
    }

}
