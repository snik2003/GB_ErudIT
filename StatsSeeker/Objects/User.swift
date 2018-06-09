//
//  User.swift
//  StatsSeeker
//
//  Created by Сергей Никитин on 08.06.2018.
//  Copyright © 2018 Sergey Nikitin. All rights reserved.
//

import Foundation
import SwiftyJSON

class User: Codable {
    var id = 0
    var isAdmin = 0
    var addedBy = 0
    var login = ""
    var email = ""
    var token = ""
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.isAdmin = json["isAdmin"].intValue
        if self.isAdmin == 0 {
            self.addedBy = json["addedBy"].intValue
        } else {
            self.addedBy = self.id
        }
        self.login = json["login"].stringValue
        self.email = json["email"].stringValue
    }
}
