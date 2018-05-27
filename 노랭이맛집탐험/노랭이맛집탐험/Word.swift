//
//  Word.swift
//  노랭이맛집탐험
//
//  Created by kpugame on 2018. 5. 25..
//  Copyright © 2018년 hwawonhan. All rights reserved.
//
import UIKit

struct Restaurant {
    var name: String?
    var adress: String?
    var category: String?
    var telephone: String?
    
    
    init(name: String?, adress: String?, category: String? , telephone: String?) {
        self.name = name
        self.adress = adress
        self.category = category
        self.telephone = telephone
        
    }
}
