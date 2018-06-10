//
//  Configuration.swift
//  StatsSeeker
//
//  Created by Сергей Никитин on 04.06.2018.
//  Copyright © 2018 Sergey Nikitin. All rights reserved.
//

import UIKit
import SwiftyJSON

final class appConfig {
    static let shared = appConfig()
    
    let appName = "ЭрудIT"
    let appSite = "https://dtgb.solutions/about-company.html"
    let appUserDefaultsKeyName = "ERUDIT_USER"
    
    let tintColor = UIColor.init(red: 52/255, green: 125/255, blue: 178/255, alpha: 1)
    let backColor = UIColor.init(red: 200/255, green: 229/255, blue: 239/255, alpha: 1)
    let textColor = UIColor.init(red: 0/255, green: 250/255, blue: 146/255, alpha: 1)
    
    let apiURL1 = "https://kruserapi.dtgb.solutions"
    let apiURL2 = "https://smallapi.dtgb.solutions"
    
    let apiVersion = "v1"
    
    var appUser = User(json: JSON.null)
}
