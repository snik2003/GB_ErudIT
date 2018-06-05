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
    
    var siteID: Int = 0
    var siteName: String = ""
    
    var wordID: Int = 0
    var wordName: String = ""
    
    init(json: JSON) {
        self.rank = json["rank"].intValue
        self.pageID = json["pageID"]["id"].intValue
        self.pageURL = json["pageID"]["url"].stringValue
        self.lastScanDate = json["pageID"]["lastScanDate"].stringValue
        self.foundDateTime = json["pageID"]["foundDateTime"].stringValue
        
        self.siteID = json["pageID"]["siteId"]["id"].intValue
        self.siteName = json["pageID"]["siteId"]["name"].stringValue
        
        self.wordID = json["personID"]["id"].intValue
        self.wordName = json["personID"]["name"].stringValue
    }
}
