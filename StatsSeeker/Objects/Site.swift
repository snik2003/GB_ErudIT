//
//  Site.swift
//  StatsSeeker
//
//  Created by Сергей Никитин on 05.06.2018.
//  Copyright © 2018 Sergey Nikitin. All rights reserved.
//

import Foundation
import SwiftyJSON

class Site: Equatable {
    static func == (lhs: Site, rhs: Site) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        return false
    }

    var id: Int = 0
    var addedBy: Int = 0
    var name: String = ""
    var siteDescription: String = ""
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.addedBy = json["addedBy"].intValue
        self.name = json["name"].stringValue
        self.siteDescription = json["siteDescription"].stringValue
    }
}
