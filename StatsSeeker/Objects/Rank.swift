//
//  Rank.swift
//  StatsSeeker
//
//  Created by Сергей Никитин on 05.06.2018.
//  Copyright © 2018 Sergey Nikitin. All rights reserved.
//

import Foundation
import SwiftyJSON

class Rank {
    var rank: Int = 0
    var pageID: Int = 0
    var pageURL: String = ""
    var lastScanDate: String = ""
    var foundDateTime: String = ""
    var site: [Site]!
    var word: [Word]!
    
    init(json: JSON) {
        self.rank = json["rank"].intValue
        self.pageID = json["pageID"]["id"].intValue
        self.pageURL = json["pageID"]["url"].stringValue
        self.lastScanDate = json["pageID"]["lastScanDate"].stringValue
        self.foundDateTime = json["pageID"]["foundDateTime"].stringValue
        
        self.site = json["pageID"]["siteID"].compactMap({ Site(json: $0.1) })
        self.word = json["pageID"]["personID"].compactMap({ Word(json: $0.1) })
    }
}
