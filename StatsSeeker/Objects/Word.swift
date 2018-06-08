//
//  Word.swift
//  StatsSeeker
//
//  Created by Сергей Никитин on 05.06.2018.
//  Copyright © 2018 Sergey Nikitin. All rights reserved.
//

import Foundation
import SwiftyJSON

class Word: Equatable {
    static func == (lhs: Word, rhs: Word) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        return false
    }
    
    var id: Int = 0
    var addedBy: Int = 0
    var name: String = ""
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.addedBy = json["addedBy"].intValue
        self.name = json["name"].stringValue
    }
}
