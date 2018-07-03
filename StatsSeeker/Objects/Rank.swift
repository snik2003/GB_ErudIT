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
    var id: Int = 0
    var rank: Int = 0
    var siteID: Int = 0
    var wordID: Int = 0
    
    var foundDate: Int = 0
    var pageID: Int = 0
    var personID: Int = 0
    var siteAddBy: Int = 0
    var wordAddBy: Int = 0
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.rank = json["person_rank"].intValue
        self.siteID = json["site_id"].intValue
        self.wordID = json["person_id"].intValue
        
        self.foundDate = json["site_found_date"].intValue
        self.pageID = json["page_id"].intValue
        self.siteAddBy = json["site_addby"].intValue
        self.wordAddBy = json["person_addby"].intValue
    }
}
